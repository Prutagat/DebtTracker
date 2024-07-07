//
//  StatisticsView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var debtManager: DebtManager
    
    var body: some View {
        NavigationView {
            Form {
                DebitCreditSection()
                SectorMarkView(debit: debtManager.totalDebit, credit: debtManager.totalCredit)
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView()
}
