//
//  DebtEditor.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 27.04.2024.
//

import SwiftUI

struct DebtEditor: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State var debt: Debt
    @State private var debtAmount: String = ""
    
    @State private var selectedUser: Profile? = nil
    @State private var showSearchSheet: Bool = false
    
    var body: some View {
        Form {
            Section {
                CustomTextFieldStack(title: "Title", text: $debt.title)
                CustomTextButton(title: "Borrower",
                                 text: Binding(get: { selectedUser?.name ?? "" },
                                               set: { _ in }),
                                 action: ({showSearchSheet = true}),
                                 imageName: "magnifyingglass.circle.fill")
                CustomTextFieldStack(title: "Amount", text: $debtAmount, keyboardType: .decimalPad) {
                    if let doubleValue = Double(debtAmount) {
                        debt.amount = doubleValue
                    }
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Description")
                        .fontWeight(.bold)
                    TextEditor(text: $debt.description)
                        .frame(height: 200)
                }
            }
            
            Toggle("isArchived", isOn: $debt.isArchived)
            
            Section {
                Button(role: .destructive, action: deleteDebt) {
                    Text("Delete")
                }
            }
        }
        .navigationTitle(debt.title.isEmpty ? "New debt".localized : debt.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done", action: addDebt)
                    .disabled(debt.title.isEmpty || selectedUser == nil || debtAmount.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            debtAmount = String(format: "%.2f", debt.amount)
            if !debt.borrowerId.isEmpty {
                fetchBorrower(by: debt.borrowerId)
            }
        }
        .sheet(isPresented: $showSearchSheet) {
            UserSearchView(selectedUser: $selectedUser, isPresented: $showSearchSheet)
                .environmentObject(appState)
        }
        .onChange(of: selectedUser) {_, newUser in
            debt.borrowerId = newUser?.id ?? ""
        }
    }
    
    func fetchBorrower(by id: String) {
        appState.userService.search(byID: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    selectedUser = user
                    debt.borrowerId = user.id
                case .failure(let error):
                    appState.showAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    func addDebt() {
        if debt.id.isEmpty {
            appState.debtService.create(debt: debt) { result in
                handleServiceResult(result)
            }
        } else {
            appState.debtService.update(debt: debt) { result in
                handleServiceResult(result)
            }
        }
    }
    
    private func handleServiceResult(_ result: Result<Void, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                dismiss()
                appState.fetchDebts()
            case .failure(let error):
                appState.showAlert(with: error.localizedDescription)
            }
        }
    }
    
    func deleteDebt() {
        appState.debtService.delete(debt: debt) { result in
            switch result {
            case .success:
                appState.fetchDebts()
                dismiss()
            case .failure(let error):
                appState.showAlert(with: error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DebtEditor(debt: AppState().testDebt)
            .environmentObject(AppState())
    }
}
