//
//  OtherSection.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 24.04.2024.
//

import SwiftUI

struct OtherSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Section("Other") {
            NavigationLink {
                DebtList(debts: appState.archivedDebts)
                    .navigationTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                OtherRow(nameImage: "book.circle", nameDetail: "History")
            }
            NavigationLink {
                ProfileView()
            } label: {
                OtherRow(nameImage: "person.crop.circle", nameDetail: "Profile")
            }
            NavigationLink {
                SettingsView()
            } label: {
                OtherRow(nameImage: "gear", nameDetail: "Settings")
            }
        }
    }
    
    private func fetchDependencies() {
        appState.fetchDebts()
    }
}

#Preview {
    NavigationView {
        Form {
            OtherSection()
                .environmentObject(AppState())
        }
    }
}
