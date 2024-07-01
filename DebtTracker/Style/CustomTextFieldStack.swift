//
//  CustomTextFieldStack.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 18.05.2024.
//

import SwiftUI

struct CustomTextFieldStack: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var onChange: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title.localized)
                .fontWeight(.bold)
            TextField(title.localized, text: $text)
                .keyboardType(keyboardType)
                .onChange(of: text, { oldValue, newValue in
                    onChange?()
                })
        }
    }
}
