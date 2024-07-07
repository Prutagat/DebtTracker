//
//  DebtDetail.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 23.04.2024.
//

import SwiftUI

struct DebtDetail: View {
    @EnvironmentObject var appState: AppState
    @State private var newDebt: Debt?
    @State private var ownerRepresentation: String = ""
    @State private var borrowerRepresentation: String = ""
    var debt: Debt
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    CustomTextStack(alignment: .center,
                                 key: "Amount",
                                 value: String(format: "%.02f ₽", debt.amount),
                                 fontValue: .title)
                    Spacer()
                }
            }
            
            Section {
                CustomTextStack(key: "Owner",
                          value: ownerRepresentation)
                CustomTextStack(key: "Borrower",
                             value: borrowerRepresentation)
            }
            
            Section {
                CustomTextStack(key: "Description",
                             value: debt.description)
            }
        }
        .navigationTitle(debt.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: debt.ownerId == appState.profileID ? Button(action: editDebt) {
                Text("Edit")
            } : nil
        )
        .onAppear {
            getRepresentation(ID: debt.ownerId) { representation in
                ownerRepresentation = representation
            }
            getRepresentation(ID: debt.borrowerId) { representation in
                borrowerRepresentation = representation
            }
        }
        .sheet(item: $newDebt) { debt in
            NavigationStack {
                DebtEditor(debt: debt)
            }
            .interactiveDismissDisabled()
        }
    }
    
    func getRepresentation(ID: String, completion: @escaping (String) -> Void) {
        appState.userService.userRepresentation(forID: ID) { result in
            switch result {
            case .success(let representation):
                completion(representation)
            case .failure(let error):
                appState.showAlert(with: error.localizedDescription)
                completion("Unknown")
            }
        }
    }
    
    func editDebt() {
        newDebt = debt
    }
}

#Preview {
    NavigationView {
        DebtDetail(debt: AppState().testDebt)
            .environmentObject(AppState())
    }
}
