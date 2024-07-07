//
//  CustomHeaderSection.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

struct CustomHeaderSection: View {
    var key: String
    var value: Double
    
    var body: some View {
        HStack {
            Text(key.localized)
            Spacer()
            Text(String(format: "%.02f ₽", value))
        }
    }
}
