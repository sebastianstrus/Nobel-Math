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
    @Environment(\.layoutDirection) var layoutDirection
    
    @State private var initialValue: Int = 0
    @State private var dragStartOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width - 30 // Account for thumb width
            let currentOffset = calculateThumbOffset(sliderWidth: sliderWidth)
            
            ZStack(alignment: .leading) {
                // Track with gradient
                LinearGradient(
                    colors: [.blue, .purple, .purple],
                    startPoint: layoutDirection == .rightToLeft ? .trailing : .leading,
                    endPoint: layoutDirection == .rightToLeft ? .leading : .trailing
                )
                .frame(height: 4)
                .cornerRadius(2)
                .padding(.horizontal, 15)
                
                // Thumb with value display
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .overlay(
                        Text("\(value)")
                            .foregroundColor(.black)
                            .font(.system(size: 10))
                    )
                    .offset(x: currentOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if dragStartOffset == 0 {
                                    initialValue = value
                                    dragStartOffset = gesture.startLocation.x - 15 // Account for padding
                                }
                                
                                let dragDistance = gesture.translation.width
                                let adjustedDistance = layoutDirection == .rightToLeft ? -dragDistance : dragDistance
                                let percentageChange = adjustedDistance / sliderWidth
                                
                                let valueRange = Double(range.upperBound - range.lowerBound)
                                let newValue = Double(initialValue) + (percentageChange * valueRange)
                                let steppedValue = Int(round(newValue / Double(step))) * step
                                value = min(max(range.lowerBound, steppedValue), range.upperBound)
                            }
                            .onEnded { _ in
                                dragStartOffset = 0
                                initialValue = 0
                            }
                    )
            }
            .frame(height: 44)
            .contentShape(Rectangle())
        }
        .frame(height: 44)
    }
    
    private func calculateThumbOffset(sliderWidth: CGFloat) -> CGFloat {
        let percentage = CGFloat(value - range.lowerBound) / CGFloat(range.upperBound - range.lowerBound)
        return percentage * sliderWidth
    }
}
