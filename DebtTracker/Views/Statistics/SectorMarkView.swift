//
//  SectorMarkView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 07.07.2024.
//

import SwiftUI
import Charts

struct DebtPart: Identifiable {
    var id = UUID()
    var title: String
    var amount: Double
}

struct SectorMarkView: View {
    var debit: Double
    var credit: Double
    
    var parts: [DebtPart] {
        [
            DebtPart(title: "Debit", amount: debit),
            DebtPart(title: "Credit", amount: credit)
        ]
    }
    
    var body: some View {
        VStack {
            Chart(parts) { part in
                SectorMark(
                    angle: .value(
                        Text(verbatim: part.title),
                        part.amount
                    ),
                    innerRadius: .ratio(0.3)
                )
                .foregroundStyle(
                    by: .value(
                        Text(verbatim: part.title),
                        part.title
                    )
                )
                .annotation(position: .overlay) {
                    Text(part.title.localized)
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(height: 300)
            .padding()
        }
    }
}

#Preview {
    SectorMarkView(debit: 50, credit: 30)
}
