//
//  ThemeManager.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 02.06.2024.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable{
    case light, dark, system
    
    var id: String { self.rawValue.localized }
}

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = AppTheme.system.rawValue
    
    var selectedTheme: AppTheme {
        didSet {
            applyTheme()
        }
    }
    
    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.system.rawValue
        self.selectedTheme = AppTheme(rawValue: savedTheme) ?? .system
    }
    
    func applyTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        var style: UIUserInterfaceStyle
        
        switch selectedTheme {
        case .light:
            style = .light
        case .dark:
            style = .dark
        case .system:
            style = .unspecified
        }
        
        windowScene.windows.forEach { window in
            UIView.transition (with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.overrideUserInterfaceStyle = style
            }, completion: nil)
        }
        
        selectedThemeRawValue = selectedTheme.rawValue
    }
}

extension ThemeManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
