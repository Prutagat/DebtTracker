//
//  Localized.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 28.04.2024.
//

import Foundation

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
}
