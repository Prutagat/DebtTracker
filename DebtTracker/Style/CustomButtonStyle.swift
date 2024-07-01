//
//  CustomButtonStyle.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 18.05.2024.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title2)
            .background(configuration.isPressed ? Color.accentColor.opacity(0.7) : Color.accentColor)
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: configuration.isPressed)
        }
}

#Preview {
    Button("Кнопка для теста") {
        print("OK")
    }
    .buttonStyle(CustomButtonStyle())
}
