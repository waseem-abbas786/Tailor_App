//
//  ButtonStyle.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import SwiftUI

import SwiftUI

struct ModernButtonModifier: ViewModifier {
    var color: Color = .blue
    var cornerRadius: CGFloat = 12
    var height: CGFloat = 50
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(cornerRadius)
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 5)
            .scaleEffect(0.98, anchor: .center)
            .animation(.easeInOut(duration: 0.15), value: UUID())
            .padding(.horizontal)
    }
}
extension View {
    func modernButtonStyle(color: Color = .blue,
                           cornerRadius: CGFloat = 12,
                           height: CGFloat = 50) -> some View {
        self.modifier(ModernButtonModifier(color: color,
                                           cornerRadius: cornerRadius,
                                           height: height))
    }
}
