//
//  CustomTextStack.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 18.05.2024.
//

import SwiftUI

struct CustomTextStack: View {
    var alignment: HorizontalAlignment = .leading
    var key: String
    var value: String
    var fontValue: Font?
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(key.localized)
                .foregroundStyle(.secondary)
            Text(value.localized)
                .font(fontValue)
        }
    }
}

#Preview {
    CustomTextStack(alignment: .center, key: "Amount", value: String(format: "%.02f ₽", 1005.23), fontValue: .title)
}
