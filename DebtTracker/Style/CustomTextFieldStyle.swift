//
//  CustomTextFieldStyle.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 18.05.2024.
//

import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .focused($isFocused)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isFocused ? Color.accentColor.opacity(0.1) : Color.clear)
                    .animation(.easeInOut(duration: 0.3), value: isFocused)
            )
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .padding(.horizontal, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 1)
                    .fill(isFocused ? Color.accentColor : (colorScheme == .dark ? Color.white : Color.gray))
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                    .animation(.easeInOut(duration: 0.3), value: isFocused),
                alignment: .bottom
            )
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldStyle())
    }
}

struct ContentView: View {
    @State private var text: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter text", text: $text)
                .customTextFieldStyle()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
