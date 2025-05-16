//
//  FallingCoinsView.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI
import MediaPlayer

struct FallingCoinsView: View {
    @State private var coins: [Coin] = []
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            
            ForEach(coins) { coin in
                Image("coin")
                    .resizable()
                    .frame(width: coin.size, height: coin.size)
                    .rotationEffect(.degrees(coin.rotation))
                    .position(x: coin.x, y: coin.y)
                    .onAppear {
                        animateCoinDrop(coin)
                    }
            }
        }
        .onAppear {
            startCoinRain()
            playCoinSound()
        }
        .onDisappear {
            stopCoinRain()
        }
    }

    func startCoinRain() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            let newCoin = Coin(
                id: UUID(),
                x: CGFloat.random(in: 0...screenWidth),
                y: -150,
                size: CGFloat.random(in: 50...200),
                rotation: Double.random(in: 0...200),
                duration: Double.random(in: 0.7...3)
            )
            coins.append(newCoin)
        }
    }

    func animateCoinDrop(_ coin: Coin) {
        if let index = coins.firstIndex(where: { $0.id == coin.id }) {
            withAnimation(.linear(duration: coin.duration)) {
                coins[index].y = screenHeight + 50
            }

            // Usunięcie monety po animacji
            DispatchQueue.main.asyncAfter(deadline: .now() + coin.duration) {
                coins.removeAll { $0.id == coin.id }
            }
        }
    }

    func stopCoinRain() {
        timer?.invalidate()
        timer = nil
    }

    func playCoinSound() {
        guard let soundURL = Bundle.main.url(forResource: "coin_sound", withExtension: "mp3") else {
            print("Failed to find a file.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // Zapętlenie dźwięku
            audioPlayer?.play()
        } catch {
            print("Błąd podczas odtwarzania dźwięku: \(error)")
        }
    }
}

struct Coin: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var rotation: Double
    var duration: Double
}
