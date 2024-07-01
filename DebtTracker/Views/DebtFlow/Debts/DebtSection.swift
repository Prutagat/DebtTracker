//
//  DebtSection.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 24.04.2024.
//

import SwiftUI

struct DebtSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Section ("Me"){
            DebtList(debts: appState.myDebts)
        }
        Section("To me") {
            DebtList(debts: appState.toMeDebts)
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
