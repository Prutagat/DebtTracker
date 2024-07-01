//
//  UserService.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 16.06.2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

// Протокол для сервиса управления пользователями
protocol UserServiceProtocol {
    func upsert(user: Profile, completion: @escaping (Result<Void, Error>) -> Void)
    func search(byID id: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func userRepresentation(forID id: String, completion: @escaping (Result<String, any Error>) -> Void)
    func search(byEmailPart emailPart: String, completion: @escaping (Result<[Profile], any Error>) -> Void)
    func search(byNamePart namePart: String, completion: @escaping (Result<[Profile], any Error>) -> Void)
}

// Реализация сервиса управления пользователями через Firebase
final class UserService: UserServiceProtocol {
    
    static let shared = UserService()
    
    private lazy var firestore = Firestore.firestore()
    
    // Создает или обновляет информацию о пользователе
    func upsert(user: Profile, completion: @escaping (Result<Void, any Error>) -> Void) {
        firestore.collection("users").document(user.id).setData(user.encodeToFireStore(), merge: true) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // Ищет пользователя по идентификатору
    func search(byID id: String, completion: @escaping (Result<Profile, any Error>) -> Void) {
        firestore.collection("users").document(id).getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot,
                  document.exists,
                  var data = document.data() else {
                completion(.failure(NSError(domain: "",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Document does not exist."])))
                return
            }
            
            data["id"] = document.documentID
            if let profile = Profile(dictionary: data) {
                completion(.success(profile))
            } else {
                completion(.failure(NSError(domain: "",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Failed to parse Profile."])))
            }
        }
    }
    
    // Возвращает представление пользователя как: Имя (Почта)
    func userRepresentation(forID id: String, completion: @escaping (Result<String, any Error>) -> Void) {
        search(byID: id) { result in
            switch result {
            case .success(let profile):
                let representation = "\(profile.name) (\(profile.email))"
                completion(.success(representation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Ищет пользователей по части электронной почты
    func search(byEmailPart emailPart: String, completion: @escaping (Result<[Profile], any Error>) -> Void) {
        let query = firestore.collection("users")
            .whereField("email", isGreaterThanOrEqualTo: emailPart)
            .whereField("email", isLessThanOrEqualTo: emailPart + "\u{f8ff}")
        
        getDocuments(query: query, completion: completion)
    }
    
    // Ищет пользователей по части имени
    func search(byNamePart namePart: String, completion: @escaping (Result<[Profile], any Error>) -> Void) {
        let query = firestore.collection("users")
            .whereField("name", isGreaterThanOrEqualTo: namePart)
            .whereField("name", isLessThanOrEqualTo: namePart + "\u{f8ff}")
        
        getDocuments(query: query, completion: completion)
    }
    
    // Общая функция получения пользователей по условиям отборов
    private func getDocuments(query: Query, completion: @escaping (Result<[Profile], any Error>) -> Void) {
        query.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            
            var profiles: [Profile] = []
            
            for document in documents {
                var data = document.data()
                data["id"] = document.documentID
                if let profile = Profile(dictionary: data) {
                    profiles.append(profile)
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Profile."])))
                    return
                }
            }
            
            completion(.success(profiles))
        }
    }
}

extension UserService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

