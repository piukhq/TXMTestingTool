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
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }

    let mid: String
    let storeID: String
    let date: Date
    let amount: Int
    let cardToken: String
    let firstSix: String
    let lastFour: String
    let settlementKey: String
    let id: String // UUID that allows us to uniquely identify a transaction
    let authCode: String // 6 digit code that is the same for auth and settle
    let psimi: String
    let secondaryMerchantId: String

        init(mid: String, storeID: String, date: Date, amount: Int, cardToken: String, firstSix: String, lastFour: String, psimi: String, secondaryMerchantId: String) {
        self.mid = mid
        self.storeID = storeID
        self.date = date
        self.amount = amount
        self.cardToken = cardToken
        self.firstSix = firstSix
        self.lastFour = lastFour
        self.settlementKey = UUID().base64uuid
        self.id = UUID().base64uuid
        self.authCode = "\(Int.random(in: 100000..<900000))"
        self.psimi = psimi
        self.secondaryMerchantId = secondaryMerchantId
    }

}

enum TransactionType {
    case auth
    case settlement
}
