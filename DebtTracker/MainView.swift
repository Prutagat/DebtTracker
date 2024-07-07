//
//  MainView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DebtsView()
                .tabItem {
                    Label("Debts", systemImage: "list.bullet")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.xaxis")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppState())
}
