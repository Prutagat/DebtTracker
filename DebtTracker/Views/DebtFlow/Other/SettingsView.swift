//
//  SettingsView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 22.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            Section {
                // Переключатель Face ID
//                HStack {
//                    Image(systemName: "faceid")
//                        .foregroundColor(.blue)
//                    Toggle("Enable Face ID", isOn: Binding(
//                        get: {
//                            faceIDManager.faceIDEnable
//                        },
//                        set: { newValue in
//                            faceIDManager.faceIDEnable = newValue
//                            if newValue {
//                                faceIDManager.authenticate { success, error in
//                                    if !success {
//                                        faceIDManager.faceIDEnable = false
//                                    }
//                                }
//                            }
//                        }
//                    ))
//                }
                // Выбор темы
                HStack {
                    Image(systemName: "paintbrush")
                        .foregroundColor(.blue)
                    Picker("Select Theme", selection: $appState.themeManager.selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.id.capitalized).tag(theme)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(FaceIDManager.shared)
        .environmentObject(ThemeManager.shared)
}
