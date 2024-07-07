//
//  CurrencyRateSection.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI

struct CurrencyRateSection: View {
    @EnvironmentObject var appState: AppState
    private var currencyRateService = CurrencyRateService()
    @State private var cnyRate: Double = 0.0
    @State private var usdRate: Double = 0.0
    @State private var eurRate: Double = 0.0
    
    var body: some View {
        Section ("Currency rate"){
            HStack {
                CustomCurrencyRepresentation(key: "CNY:", value: cnyRate)
                Spacer()
                CustomCurrencyRepresentation(key:"USD:", value: usdRate)
                Spacer()
                CustomCurrencyRepresentation(key:"EUR:", value: eurRate)
            }
        }
        .onAppear() {
            fetchCurrencyRates()
        }
    }
    
    func fetchCurrencyRates() {
        fetchCurrencyRate(for: "CNY") { rate in
            self.cnyRate = rate
        }
        fetchCurrencyRate(for: "USD") { rate in
            self.usdRate = rate
        }
        fetchCurrencyRate(for: "EUR") { rate in
            self.eurRate = rate
        }
    }
    
    func fetchCurrencyRate(for currency: String, completion: @escaping (Double) -> Void) {
        currencyRateService.fetchCurrencyRate(rate: currency) { rate, error in
            DispatchQueue.main.async {
                if let error = error {
                    appState.showAlert(with: error)
                } else {
                    completion(rate)
                }
            }
        }
    }
}

#Preview {
    CurrencyRateSection()
        .environmentObject(AppState())
}
