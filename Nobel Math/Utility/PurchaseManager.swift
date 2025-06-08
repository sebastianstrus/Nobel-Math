//
//  PurchaseManager.swift
//  Nobel Math
//
//  Created by Sebastian Strus on 6/8/25.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {

    private let productIds = [
        "com.sebastianstrus.noblamathapp.premium.monthly",
        "con.sebastianstrus.noblamath.yearly.access"
    ]

    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var purchasedProductIDs = Set<String>()

    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil

    init() {
        self.updates = observeTransactionUpdates()
    }

    deinit {
        self.updates?.cancel()
    }

    var hasUnlockedPro: Bool {
       return !self.purchasedProductIDs.isEmpty
    }

    func loadProducts() async throws {
        print("TEST100 loadProducts")
        guard !self.productsLoaded else { return }
        
        self.products = try await Product.products(for: productIds)
        print("TEST100 productsLoaded: \(self.productsLoaded)")
        print("TEST100 products.count: \(self.products.count)")
        self.productsLoaded = true
    }

    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            // Successful purchase
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}
