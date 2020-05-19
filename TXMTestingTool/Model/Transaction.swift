//
//  Transaction.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 31/03/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

class Transaction: Codable {
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
    let id: String // UUID that allows us to uniquely identify a transaction
    let authCode: String // 6 digit code that is the same for auth and settle

    init(mid: String, date: Date, amount: Int, cardToken: String, firstSix: String, lastFour: String) {
        self.mid = mid
        self.date = date
        self.amount = amount
        self.cardToken = cardToken
        self.firstSix = firstSix
        self.lastFour = lastFour
        self.settlementKey = Transaction.generateUUID()
        self.id = Transaction.generateUUID()
        self.authCode = "\(Int.random(in: 100000..<900000))"
    }
    
    private static func generateUUID() -> String {
        guard let uuid = UUID().uuidString.data(using: .utf8)?.base64EncodedString() else {
            // This should never happen as we trust .uuidString to always return a valid utf8 string.
            fatalError("Failed to generate base64-encoded UUID string")
        }
        return uuid
    }
}

enum TransactionType {
    case auth
    case settlement
}
