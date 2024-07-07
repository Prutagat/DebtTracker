//
//  DebtSection.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 24.04.2024.
//

import SwiftUI

struct DebtSection: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var debtManager: DebtManager
    
    var body: some View {
        Group {
            Section {
                DebtList(debts: debtManager.myDebts)
            } header: {
                CustomHeaderSection(key: "Me", value: debtManager.totalCredit)
            }
            Section {
                DebtList(debts: debtManager.toMeDebts)
            } header: {
                CustomHeaderSection(key: "To me", value: debtManager.totalDebit)
            }
        }
        .onAppear() {
            fetchDebts()
        }
    }
    
    private func fetchDebts() {
        debtManager.fetchDebts(profileID: appState.profileID) { error in
            if let error {
                appState.showAlert(with: error)
            }
        }
    }
}

#Preview {
    NavigationView {
        Form {
            DebtSection()
                .environmentObject(AppState())
        }
    }
}
