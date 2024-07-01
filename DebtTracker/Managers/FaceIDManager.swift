//
//  FaceIDManager.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 23.06.2024.
//

import SwiftUI
import LocalAuthentication

final class FaceIDManager: ObservableObject {
    static let shared = FaceIDManager()
    
    @AppStorage("faceIDEnable") private var faceIDEnableStorage: Bool = false
    
    var faceIDEnable: Bool {
        didSet {
            faceIDEnableStorage = faceIDEnable
        }
    }
    
    init() {
        let faceIDEnableStorage = UserDefaults.standard.bool(forKey: "faceIDEnable")
        self.faceIDEnable = faceIDEnableStorage
    }
        
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

extension FaceIDManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
