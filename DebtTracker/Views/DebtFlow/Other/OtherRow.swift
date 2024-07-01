//
//  OtherRow.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 27.04.2024.
//

import SwiftUI

struct OtherRow: View {
    var nameImage: String
    var nameDetail: String
    
    var body: some View {
        HStack {
            Image(systemName: nameImage)
            Text(nameDetail.localized)
        }
    }
}

#Preview {
    OtherRow(nameImage: "book.circle", nameDetail: "History")
}
