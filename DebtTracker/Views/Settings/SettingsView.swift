//
//  SettingsView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 22.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var faceIDManager: FaceIDManager
    
    var body: some View {
        NavigationView {
            Form {
                // Выбор темы
                Section {
                    HStack {
                        Image(systemName: "paintbrush")
                            .foregroundColor(.blue)
                        Picker("Select Theme", selection: $themeManager.appTheme) {
                            ForEach(AppTheme.allCases) { theme in
                                Text(theme.id.capitalized).tag(theme)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Переключатель Face ID
                    HStack {
                        Image(systemName: "faceid")
                            .foregroundColor(.blue)
                        Toggle("Enable Face ID", isOn: Binding(
                            get: {
                                faceIDManager.faceIDEnable
                            },
                            set: { newValue in
                                faceIDManager.faceIDEnable = newValue
                                if newValue {
                                    faceIDManager.authenticate { success, error in
                                        if let error {
                                            faceIDManager.faceIDEnable = false
                                            appState.showAlert(with: error)
                                            return
                                        }
                                    }
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(ThemeManager())
}
