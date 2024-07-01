//
//  DebtService.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 10.05.2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

// Протокол для сервиса управления долгами
protocol DebtServiceProtocol {
    func create(debt: Debt, completion: @escaping (Result<Void, Error>) -> Void)
    func update(debt: Debt, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(debt: Debt, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchMyDebts(profileID: String, completion: @escaping (Result<[Debt], Error>) -> Void)
    func fetchToMeDebts(profileID: String, completion: @escaping (Result<[Debt], Error>) -> Void)
    func fetchArchiveDebts(profileID: String, completion: @escaping (Result<[Debt], Error>) -> Void)
}

// Реализация сервиса управления долгами через Firebase
final class DebtService: DebtServiceProtocol {
    static let shared = DebtService()
    
    private lazy var firestore = Firestore.firestore()
    
    // Создание нового долга
    func create(debt: Debt, completion: @escaping (Result<Void, Error>) -> Void) {
        firestore.collection("debts").addDocument(data: debt.encodeToFireStore()) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // Обновление существующего долга
    func update(debt: Debt, completion: @escaping (Result<Void, Error>) -> Void) {
        let documentRef = firestore.collection("debts").document(debt.id)
        
        documentRef.updateData(debt.encodeToFireStore()) { error in
            if let error = error {
                if (error as NSError).code == FirestoreErrorCode.notFound.rawValue {
                    completion(.failure(NSError(domain: "",
                                                code: FirestoreErrorCode.notFound.rawValue,
                                                userInfo: [NSLocalizedDescriptionKey: "Document not found."])))
                } else {
                    completion(.failure(error))
                }
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Удаление долга
    func delete(debt: Debt, completion: @escaping (Result<Void, Error>) -> Void) {
        firestore.collection("debts").document("\(debt.id)").delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    // Получение долгов, которые должен пользователь
    func fetchMyDebts(profileID: String, completion: @escaping (Result<[Debt], Error>) -> Void) {
        let query = firestore.collection("debts")
            .whereField("borrowerId", isEqualTo: profileID)
            .whereField("isArchived", isEqualTo: false)
        
        fetchDebts(query: query, completion: completion)
    }
    
    // Получение долгов, которые должны пользователю
    func fetchToMeDebts(profileID: String, completion: @escaping (Result<[Debt], Error>) -> Void) {
        let query = firestore.collection("debts")
            .whereField("ownerId", isEqualTo: profileID)
            .whereField("isArchived", isEqualTo: false)
        
        fetchDebts(query: query, completion: completion)
    }
    
    // Получение архивированных долгов
    func fetchArchiveDebts(profileID: String, completion: @escaping (Result<[Debt], Error>) -> Void) {
        let ownerQuery = firestore.collection("debts")
            .whereField("ownerId", isEqualTo: profileID)
            .whereField("isArchived", isEqualTo: true)
        
        let borrowerQuery = firestore.collection("debts")
            .whereField("borrowerId", isEqualTo: profileID)
            .whereField("isArchived", isEqualTo: true)
        
        var debts: [Debt] = []
        var fetchError: Error?
        
        let group = DispatchGroup()
        
        group.enter()
        fetchDebts(query: ownerQuery) { result in
            switch result {
            case .success(let ownerDebts):
                debts.append(contentsOf: ownerDebts)
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.enter()
        fetchDebts(query: borrowerQuery) { result in
            switch result {
            case .success(let borrowerDebts):
                debts.append(contentsOf: borrowerDebts)
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                let uniqueDebts = Array(Set(debts))
                completion(.success(uniqueDebts))
            }
        }
    }
    
    // Вспомогательная функция для получения долгов по запросу
    private func fetchDebts(query: Query, completion: @escaping (Result<[Debt], Error>) -> Void) {
        query.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            
            var debts: [Debt] = []
            
            for document in documents {
                var data = document.data()
                data["documentID"] = document.documentID
                if let debt = Debt(dictionary: data) {
                    debts.append(debt)
                } else {
                    completion(.failure(NSError(domain: "",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Failed to parse Debt."])))
                    return
                }
            }
            
            completion(.success(debts))
        }
    }
}

extension DebtService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
