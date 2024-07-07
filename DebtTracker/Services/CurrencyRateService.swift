//
//  CurrencyRateService.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

final class CurrencyRateService: ObservableObject {

    func fetchCurrencyRate(rate: String, completion: @escaping (Double, String?) -> Void) {
        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/\(rate)") else {
            completion(0, "Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(0, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(0, "No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let rates = json["rates"] as? [String: Double],
                   let rateInRub = rates["RUB"] {
                    completion(rateInRub, nil)
                } else {
                    completion(0, "Invalid response format")
                }
            } catch {
                completion(0, error.localizedDescription)
            }
        }
        task.resume()
    }
}
