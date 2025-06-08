//
//  ContentView.swift
//  Nobel Math
//
//  Created by Sebastian Strus on 6/8/25.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]

    @State
    private var products: [Product] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Products")
            ForEach(self.products) { product in
                Button {
                    // Don't do anything yet
                } label: {
                    Text("\(product.displayPrice) - \(product.displayName)")
                }
            }
        }.task {
            do {
                try await self.loadProducts()
            } catch {
                print(error)
            }
        }
    }

    private func loadProducts() async throws {
        self.products = try await Product.products(for: productIds)
    }
}
