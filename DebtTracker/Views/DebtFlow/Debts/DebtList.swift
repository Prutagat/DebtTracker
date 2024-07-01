//
//  DebtList.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 24.04.2024.
//

import SwiftUI

struct DebtList: View {
    var debts: [Debt]
    
    var body: some View {
        List(debts) { debt in
            NavigationLink {
                DebtDetail(debt: debt)
            } label: {
                DebtRow(debt: debt)
            }
        }
    }
}

#Preview {
    NavigationView {
        DebtList(debts: [AppState().testDebt])
    }
}
