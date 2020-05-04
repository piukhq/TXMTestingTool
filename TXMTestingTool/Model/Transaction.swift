//
//  Transaction.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 31/03/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct Transaction {
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter
    }

    let mid: String
    let date: Date
    let amount: Int
    let cardToken: String
    let firstSix: String
    let lastFour: String
    let settlementKey: String

    init(mid: String, date: Date, amount: Int, cardToken: String, firstSix: String, lastFour: String) {
        self.mid = mid
        self.date = date
        self.amount = amount
        self.cardToken = cardToken
        self.firstSix = firstSix
        self.lastFour = lastFour

        guard let settlementKey = UUID().uuidString.data(using: .utf8)?.base64EncodedString() else {
            // This should never happen as we trust .uuidString to always return a valid utf8 string.
            fatalError("Failed to generate base64-encoded UUID string for settlement key.")
        }
        self.settlementKey = settlementKey
    }
}
