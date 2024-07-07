//
//  ProfileView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 22.04.2024.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 100))
                        .padding()
                    
                    Divider()
                    
                    if appState.isAuthorized {
                        Text("ID" + ": \(appState.profileID)")
                        Text("Email" + ": \(appState.profileEmail)")
                        Text("Name" + ": \(appState.profileName)")
                    } else {
                        Text("User is not authorized")
                    }
                    
                    Spacer()
                }
                .padding()
                
                Button("Exit") {
                    signOut()
                }
                .buttonStyle(CustomButtonStyle())
            }
            .navigationTitle("Profile")
        }
    }
    
    func signOut() {
        appState.authenticationService.signOut { result in
            switch result {
            case .success:
                appState.resetProfile()
            case .failure(let error):
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}

