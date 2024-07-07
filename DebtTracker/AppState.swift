//
//  AppState.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 08.05.2024.
//

import SwiftUI

// Класс AppState управляет состоянием приложения и связанными данными
final class AppState: ObservableObject {
    
    // Состояние авторизации и профиль пользователя, сохраняемые в UserDefaults
    @AppStorage("isAuthorized") var isAuthorized: Bool = false
    @AppStorage("profileID") var profileID: String = ""
    @AppStorage("profileName") var profileName: String = ""
    @AppStorage("profileEmail") var profileEmail: String = ""
    
    // Профиль пользователя
    @Published var profile: Profile?
    
    // Сервисы для аутентификации, управления долгами и пользователями
    let authenticationService = AuthenticationService.shared
    let userService = UserService.shared
    
    // Параметры для отображения предупреждений
    @Published var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    // Функция для отображения предупреждения
    func showAlert(title: String = "Error", with message: String) {
        self.alertTitle = title.localized
        self.alertMessage = message.localized
        self.showAlert = true
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
