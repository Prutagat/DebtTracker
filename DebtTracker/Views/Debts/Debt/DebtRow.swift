//
//  DebtRow.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 24.04.2024.
//

import SwiftUI

struct DebtRow: View {
    var debt: Debt
    
    var body: some View {
        HStack {
            Text(debt.title)
            Spacer()
            Text(String(format: "%.02f ₽", debt.amount))
        }
        .foregroundStyle(debt.isArchived ? .secondary : .primary)
    }
}

#Preview {
    DebtRow(debt: AppState().testDebt)
}
