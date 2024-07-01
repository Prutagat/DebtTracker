//
//  Debt.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 23.04.2024.
//

import FirebaseFirestore

struct Debt: Hashable, Codable, Identifiable {
    var id: String
    let ownerId: String
    var borrowerId: String
    var title: String
    var amount: Double
    var description: String
    var isArchived: Bool
    
    init(ownerId: String,
         borrowerId: String = "",
         id: String = "",
         title: String = "",
         amount: Double = 0,
         description: String = "",
         isArchived: Bool = false) {
        self.id = id
        self.ownerId = ownerId
        self.borrowerId = borrowerId
        self.title = title
        self.amount = amount
        self.description = description
        self.isArchived = isArchived
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["documentID"] as? String,
              let ownerId = dictionary["ownerId"] as? String,
              let borrowerId = dictionary["borrowerId"] as? String,
              let title = dictionary["title"] as? String,
              let amount = dictionary["amount"] as? Double,
              let description = dictionary["description"] as? String,
              let isArchived = dictionary["isArchived"] as? Bool else {
            return nil
        }
        
        self.id = id
        self.ownerId = ownerId
        self.borrowerId = borrowerId
        self.title = title
        self.amount = amount
        self.description = description
        self.isArchived = isArchived
    }
    
    func encodeToFireStore() -> [String: Any] {
        [
            "ownerId": ownerId,
            "borrowerId": borrowerId,
            "title": title,
            "amount": amount,
            "description": description,
            "isArchived": isArchived
        ]
    }
}
