//
//  Profile.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 23.04.2024.
//

import FirebaseAuth

struct Profile: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    
    init(user: User) {
        self.id = user.uid
        self.name = user.displayName ?? ""
        self.email = user.email ?? ""
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.email = ""
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let email = dictionary["email"] as? String else {
                  return nil
              }
        
        self.id = id
        self.name = name
        self.email = email
    }
    
    func encodeToFireStore() -> [String: Any] {
        [
            "name" : name,
            "email": email.lowercased()
        ]
    }
}
