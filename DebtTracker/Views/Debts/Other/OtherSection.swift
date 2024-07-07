//
//  OtherSection.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 24.04.2024.
//

import SwiftUI

struct OtherSection: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var debtManager: DebtManager
    
    var body: some View {
        Section("Other") {
            NavigationLink {
                DebtList(debts: debtManager.archivedDebts)
                    .navigationTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                OtherRow(nameImage: "clock", nameDetail: "History")
            }
            .onAppear() {
                
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
            OtherSection()
                .environmentObject(AppState())
                .environmentObject(DebtManager())
        }
    }
}
