//
//  FaceIDManager.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 23.06.2024.
//

import SwiftUI
import LocalAuthentication

final class FaceIDManager: ObservableObject {
    @AppStorage("faceIDEnable") var faceIDEnable: Bool = false
    @Published var isAuthenticating = false
        
    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Проверяем, поддерживает ли устройство биометрическую аутентификацию
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to authenticate you to proceed."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    completion(true, nil)
                } else {
                    completion(false, authenticationError?.localizedDescription ?? "Failed to authenticate")
                }
            }
        } else {
            completion(false, error?.localizedDescription ?? "Biometrics not available")
        }
    }
}
