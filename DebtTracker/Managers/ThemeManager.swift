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
    @AppStorage("appTheme") var appTheme: AppTheme = .system {
        didSet {
            applyTheme()
        }
    }
    
    init() {
        applyTheme()
    }
    
    func applyTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        var style: UIUserInterfaceStyle
        
        switch appTheme {
        case .light:
            style = .light
        case .dark:
            style = .dark
        case .system:
            style = .unspecified
        }
        
        windowScene.windows.forEach { window in
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.overrideUserInterfaceStyle = style
            }, completion: nil)
        }
    }
}
