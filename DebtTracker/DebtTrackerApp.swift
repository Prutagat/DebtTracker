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
    @StateObject var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isAuthorized {
                    DebtsView()
                } else {
                    AuthorizationView()
                }
            }
            .onAppear {
                appState.themeManager.applyTheme()
            }
            .onChange(of: appState.themeManager.selectedTheme) { _, _ in
                appState.themeManager.applyTheme()
            }
            .environmentObject(appState)
            .alert(isPresented: $appState.showAlert) {
                Alert(title: Text(appState.alertTitle),
                      message: Text(appState.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
