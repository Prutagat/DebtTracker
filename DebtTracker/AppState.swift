//
//  AppState.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 08.05.2024.
//

import SwiftUI
import Foundation

// Класс AppState управляет состоянием приложения и связанными данными
final class AppState: ObservableObject {
    static let shared = AppState()
    
    // Состояние авторизации и профиль пользователя, сохраняемые в UserDefaults
    @AppStorage("isAuthorized") var isAuthorized: Bool = false
    @AppStorage("profileID") var profileID: String = ""
    @AppStorage("profileName") var profileName: String = ""
    @AppStorage("profileEmail") var profileEmail: String = ""
    
    // Профиль пользователя и списки долгов
    @Published var profile: Profile?
    @Published var toMeDebts: [Debt] = []
    @Published var myDebts: [Debt] = []
    @Published var archivedDebts: [Debt] = []
    
    // Cостояние загрузки
    @Published var loading = false
    
    // Параметры для отображения предупреждений
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    // Менеджеры для управления темами и Face ID
    var themeManager = ThemeManager.shared
    var faceIDManager = FaceIDManager.shared
    
    // Сервисы для аутентификации, управления долгами и пользователями
    let authenticationService = AuthenticationService.shared
    let debtService = DebtService.shared
    let userService = UserService.shared
    
    // Функция для отображения предупреждения
    func showAlert(title: String = "Error", with message: String) {
        self.alertTitle = title.localized
        self.alertMessage = message.localized
        self.showAlert = true
    }
    
    // Функция для загрузки долгов пользователя
    func fetchDebts() {
        loading = true
        let group = DispatchGroup()
        
        group.enter()
        debtService.fetchToMeDebts(profileID: profileID) { result in
            switch result {
            case .success(let debts):
                self.toMeDebts = debts
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        debtService.fetchMyDebts(profileID: profileID) { result in
            switch result {
            case .success(let debts):
                self.myDebts = debts
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        debtService.fetchArchiveDebts(profileID: profileID) { result in
            switch result {
            case .success(let debts):
                self.archivedDebts = debts
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.loading = false
        }
    }
    
    // Функция для обновления профиля пользователя
    func updateProfile(id: String? = nil, name: String? = nil, email: String? = nil, profile: Profile? = nil) {
        if let profile {
            self.profileID = profile.id
            self.profileName = profile.name
            self.profileEmail = profile.email
        } else {
            if let id {
                self.profileID = id
            }
            if let name {
                self.profileName = name
            }
            if let email {
                self.profileEmail = email
            }
        }
        self.isAuthorized = true
    }
    
    // Функция для сброса профиля пользователя
    func resetProfile() {
        self.isAuthorized = false
        self.profileID = ""
        self.profileName = ""
        self.profileEmail = ""
        self.profile = nil
    }
    
    // Тестовые данные долга для примера
    var testDebt = Debt(ownerId: UUID().uuidString,
                                   borrowerId: UUID().uuidString,
                                   id: UUID().uuidString,
                                   title: "Тестовая зависимость",
                                   amount: 10512.50,
                                   description: "Это тестовая зависимость для отображения примера заполнения данными",
                                   isArchived: false)
}

extension AppState: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
