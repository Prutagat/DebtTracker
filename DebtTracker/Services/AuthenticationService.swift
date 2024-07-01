//
//  AuthenticationService.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 01.05.2024.
//

import Foundation
import FirebaseAuth

// Перечисление возможных ошибок аутентификации
enum AuthenticationError: Error {
    case notAuthorized
    case custom(String)
}

// Протокол для сервиса аутентификации
protocol AuthenticationServiceProtocol {
    func signUp(name: String, email: String, password: String, complection: @escaping (Result<Profile, AuthenticationError>) -> Void)
    func signIn(email: String, password: String, complection: @escaping (Result<Profile, AuthenticationError>) -> Void)
    func signOut(completion: @escaping (Result<Void, AuthenticationError>) -> Void)
    func isAuthorized() -> Bool
}

// Реализация сервиса аутентификации через Firebase
final class AuthenticationService: AuthenticationServiceProtocol {
    static let shared = AuthenticationService()
    private let firebaseAuth = Auth.auth()
    
    // Регистрация нового пользователя
    func signUp(name: String,
                email: String,
                password: String,
                complection: @escaping (Result<Profile, AuthenticationError>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                complection(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let userFire = authResult?.user else {
                complection(.failure(.notAuthorized))
                return
            }
            
            let changeRequest = userFire.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error {
                    complection(.failure(.custom(error.localizedDescription)))
                    return
                }
                
                let profile = Profile(user: userFire)
                complection(.success(profile))
            }
        }
    }
    
    // Вход пользователя в систему
    func signIn(email: String,
                password: String,
                complection: @escaping (Result<Profile, AuthenticationError>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                complection(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let userFire = authResult?.user else {
                complection(.failure(.notAuthorized))
                return
            }
            
            let profile = Profile(user: userFire)
            complection(.success(profile))
        }
    }
    
    // Выход пользователя из системы
    func signOut(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        do {
            try firebaseAuth.signOut()
            completion(.success(()))
        } catch {
            completion(.failure(.custom(error.localizedDescription)))
        }
    }
    
    // Проверка авторизации пользователя
    func isAuthorized() -> Bool {
        firebaseAuth.currentUser != nil
    }
}

extension AuthenticationService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
