//
//  AuthorizationView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 06.05.2024.
//

import SwiftUI

struct AuthorizationView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isSignUpPresented = false
    @State private var isSignInPresented = false
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: UIImage(named: "Logo") ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 400)
                
                Button("Sign up") {
                    isSignUpPresented.toggle()
                }
                .buttonStyle(CustomButtonStyle())
                
                HStack {
                    Text("Have an account?")
                    Button("Sign in") {
                        isSignInPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isSignUpPresented) {
                SignUpView()
            }
            .sheet(isPresented: $isSignInPresented) {
                SignInView()
            }
        }
    }
}

#Preview {
    AuthorizationView()
}
