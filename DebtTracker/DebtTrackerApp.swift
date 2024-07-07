//
//  DebtTrackerApp.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 18.05.2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct DebtTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var appState = AppState()
    @StateObject var themeManager = ThemeManager()
    @StateObject var faceIDManager = FaceIDManager()
    @StateObject var debtManager = DebtManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isAuthorized {
                    ZStack {
                        if faceIDManager.isAuthenticating {
                            ProgressView()
                        }
                        else {
                            MainView()
                        }
                    }
                    .onAppear(perform: authenticateUser)
                } else {
                    AuthorizationView()
                }
            }
            .onAppear {
                themeManager.applyTheme()
            }
            .onChange(of: themeManager.appTheme) { _, _ in
                themeManager.applyTheme()
            }
            .alert(isPresented: $appState.showAlert) {
                Alert(title: Text(appState.alertTitle),
                      message: Text(appState.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .environmentObject(appState)
            .environmentObject(themeManager)
            .environmentObject(faceIDManager)
            .environmentObject(debtManager)
        }
    }
    
    private func authenticateUser() {
        if faceIDManager.faceIDEnable {
            faceIDManager.isAuthenticating = true
            faceIDManager.authenticate { success, error in
                faceIDManager.isAuthenticating = false
                if let error {
                    appState.showAlert(with: error)
                    appState.isAuthorized = false
                }
            }
        }
    }
}
