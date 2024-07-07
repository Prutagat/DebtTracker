//
//  DebtsView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 22.04.2024.
//

import SwiftUI

struct DebtsView: View {
    @EnvironmentObject var appState: AppState
    @State private var newDebt: Debt?
    
    var body: some View {
        NavigationView {
            Form {
                CurrencyRateSection()
                DebtSection()
                OtherSection()
            }
            .navigationTitle("Debts")
            .navigationBarItems(
                trailing: Button(action: createDebt) {
                    Label("Add Item", systemImage: "plus")
                }
            )
            .sheet(item: $newDebt) { debt in
                NavigationStack {
                    DebtEditor(debt: debt)
                        .environmentObject(appState)
                }
                .interactiveDismissDisabled()
            }
        }
    }
    
    func createDebt() {
        newDebt = Debt(ownerId: appState.profileID)
    }
}

#Preview {
    DebtsView()
        .environmentObject(AppState())
}
