//
//  CustomTextButton.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 01.07.2024.
//

import SwiftUI

struct CustomTextButton: View {
    let title: String
    @Binding var text: String
    var action: (() -> Void)
    var imageName: String
    
    var body: some View {
        HStack {
            Text(title.localized)
                .fontWeight(.bold)
            Text(text.localized)
                .foregroundColor(.primary)
            Spacer()
            Button(action: {
                action()
            }) {
                Image(systemName: imageName)
            }
        }
    }
}
