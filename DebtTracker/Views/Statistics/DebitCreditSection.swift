//
//  DebitCreditSection.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

struct DebitCreditSection: View {
    @EnvironmentObject var debtManager: DebtManager
    @State private var totalDebit: Double = 0.0
    @State private var totalCredit: Double = 0.0
    
    var body: some View {
        Section {
            VStack {
                CustomHeaderSection(key: "Debit", value: debtManager.totalDebit)
                CustomHeaderSection(key: "Credit", value: debtManager.totalCredit)
                CustomHeaderSection(key: "Balance", value: debtManager.totalDebit - debtManager.totalCredit)
            }
        }
    }
}
