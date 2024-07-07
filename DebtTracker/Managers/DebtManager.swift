//
//  DebtManager.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

final class DebtManager: ObservableObject {
    let debtService = DebtService.shared
    
    // Списки долгов
    @Published var toMeDebts: [Debt] = []
    @Published var myDebts: [Debt] = []
    @Published var archivedDebts: [Debt] = []
    
    var totalDebit: Double {
        return toMeDebts.reduce(0) { $0 + $1.amount }
    }
    
    var totalCredit: Double {
        return myDebts.reduce(0) { $0 + $1.amount }
    }
    
    func fetchDebts(profileID: String,completion: @escaping (String?) -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        debtService.fetchToMeDebts(profileID: profileID) { result in
            switch result {
            case .success(let debts):
                self.toMeDebts = debts
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        debtService.fetchMyDebts(profileID: profileID) { result in
            switch result {
            case .success(let debts):
                self.myDebts = debts
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        debtService.fetchArchiveDebts(profileID: profileID) { result in
            switch result {
            case .success(let debts):
                self.archivedDebts = debts
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
            group.leave()
        }
    }
    
}
