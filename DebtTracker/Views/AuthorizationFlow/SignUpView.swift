//
//  SignUpView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 06.05.2024.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack {
            Text("Registration")
                .font(.title)
                .fontWeight(.heavy)
            
            VStack {
                TextField("Name", text: $name)
                    .customTextFieldStyle()
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .customTextFieldStyle()
                SecureField("Password", text: $password)
                    .customTextFieldStyle()
                SecureField("Repeat password", text: $confirmPassword)
                    .customTextFieldStyle()
            }
            .padding()
            
            Button("Sign up") {
                signUp()
            }
            .disabled(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            .buttonStyle(CustomButtonStyle())
        }
        .alert(isPresented: $appState.showAlert) {
            Alert(
                title: Text(appState.alertTitle),
                message: Text(appState.alertMessage),
                dismissButton: .default(Text("Cancel"))
            )
        }
    }
    
    private func signUp() {
        guard password == confirmPassword else {
            appState.showAlert(with: "Passwords do not match.")
            return
        }
        
        appState.authenticationService.signUp(name: name, email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    appState.updateProfile(profile: profile)
                    appState.isAuthorized = appState.authenticationService.isAuthorized()
                    appState.userService.upsert(user: profile) { result in
                        switch result {
                        case .success:
                            return
                        case .failure(let error):
                            appState.showAlert(with: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    switch error {
                    case let .custom(text):
                        appState.showAlert(with: text.localized)
                    case .notAuthorized:
                        appState.showAlert(with: "The user is not logged in.")
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AppState())
}
