//
//  View+Extensions.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI
import SwiftUI
import MessageUI
import UIKit


extension View {
    
    
    
    
    func styledSlider() -> some View {
        
        return self
        
            .frame(width: 100, height: 50)
            .cornerRadius(12)
        
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.white))
                    .frame(width: 100, height: 4)
                    .allowsHitTesting(false)
                
            )
        
            .overlay(
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 2, height: 8)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 2, height: 8)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color(.white))
                        .frame(width: 2, height: 8)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color(.white))
                        .frame(width: 2, height: 8)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color(.white))
                        .frame(width: 2, height: 8)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color(.white))
                        .frame(width: 2, height: 8)
                    
                }.allowsHitTesting(false)
                    .frame(width: 94)
            )
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: 50)
                    .cornerRadius(12)
            )
            .cornerRadius(12)
            .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
            .accentColor(Color(.white))
    }
}


