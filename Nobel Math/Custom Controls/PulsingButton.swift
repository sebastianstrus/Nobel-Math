//
//  PulsingButton.swift
//  Nobel Math
//
//  Created by Sebastian Strus on 2025-05-07.
//

import SwiftUI

struct PulsingButton: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Text(title)
            .font(Font.system(size: 20))
            .fontWeight(.bold)
            .frame(width: width, height: height)
            .background(Color.blue.opacity(0.93))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white, lineWidth: 1)
            )
            .scaleEffect(scale)
            .onAppear {
                let animation = Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)
                DispatchQueue.main.async {
                    withAnimation(animation) {
                        scale = 1.1
                    }
                }
            }
    }
}
