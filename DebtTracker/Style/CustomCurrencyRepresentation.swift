//
//  CustomCurrencyRepresentation.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

struct CustomCurrencyRepresentation: View {
    var key: String
    var value: Double
    
    var body: some View {
        HStack {
            Text(key)
                .fontWeight(.bold)
            Text(String(format: "%.02f ₽", value))
                .foregroundColor(.primary)
        }
        .font(.system(size: 14))
    }
}

#Preview {
    CustomCurrencyRepresentation(key: "CNY", value: 105.123)
}
