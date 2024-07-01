//
//  SignInView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.05.2024.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Text("Sign in")
            .font(.title)
            .fontWeight(.heavy)
        
        VStack {
            TextField("Email", text: $email)
                .customTextFieldStyle()
            SecureField("Password", text: $password)
                .customTextFieldStyle()
        }
        .padding()
        
        Button("Sign in") {
            signIn()
        }
        .disabled(email.isEmpty || password.isEmpty)
        .buttonStyle(CustomButtonStyle())
        .alert(isPresented: $appState.showAlert) {
            Alert(
                title: Text(appState.alertTitle),
                message: Text(appState.alertMessage),
                dismissButton: .default(Text("Cancel"))
            )
        }
    }
    
    private func signIn() {
        appState.authenticationService.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    appState.updateProfile(profile: profile)
                    appState.isAuthorized = appState.authenticationService.isAuthorized()
                case .failure(let error):
                    switch error {
                    case let .custom(message):
                        appState.showAlert(with: message)
                    case .notAuthorized:
                        appState.showAlert(with: "The user is not logged in.")
                    }
                }
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AppState())
}
