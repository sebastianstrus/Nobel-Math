//
//  GradientSlider.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI

struct GradientSlider: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    var step: Int

    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width

            ZStack(alignment: .leading) {
                LinearGradient(colors: [.blue, .purple, .purple], startPoint: .leading, endPoint: .trailing)
                    .frame(height: 4)
                    .cornerRadius(2)
                    .padding(.leading, 15)
                    .padding(.trailing, -15)

                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .overlay(
                        Text("\(value)")
                            .foregroundColor(.black)
                            .font(Font.system(size: 10))
                    )
                    .offset(x: CGFloat(Double(value - range.lowerBound) / Double(range.upperBound - range.lowerBound)) * (sliderWidth - 30))
                    
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let location = gesture.location.x
                                let newValue = Double(location / (sliderWidth - 30)) * Double(range.upperBound - range.lowerBound) + Double(range.lowerBound)
                                let roundedValue = Int(round(newValue / Double(step))) * step
                                value = min(max(range.lowerBound, roundedValue), range.upperBound)
                            }
                    )
            }
            .frame(height: 44)
            .padding(.horizontal, 15)
        }.frame(height: 44)
    }
}
