//
//  AmexAuthProvider.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 11/05/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct AmexAuthProvider: Provider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        let amexTransactions = transactions.map {
            AmexAuthTransaction(
                approvalCode: $0.authCode,
                cmAlias: $0.cardToken,
                merchantNumber: $0.mid,
                offerID: "0",
                transactionAmount: String(format: "%.02f", Double($0.amount) / 100.0),
                transactionCurrency: "UKL",
                transactionID: UUID().uuidString,
                transactionTime: dateFormatter.string(from: $0.date)
            )
        }
        
        let data = try jsonEncoder.encode(amexTransactions)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Properties

    var defaultFileName = "amex-auth.json"

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: -25200)  // UTC-7
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
}

// MARK: - JSON Codables

struct AmexAuthTransaction: Codable {
    var approvalCode: String            // 6 digit number
    var cmAlias: String                 // Card token
    var merchantNumber: String          // MID
    var offerID: String                 // Offer for a merchant if applicable, 0 if not
    var transactionAmount: String       // 2 decimal place pound value (65.52)
    var transactionCurrency: String     // UKL = GBP, strange outdated currency, hardcode for now
    var transactionID: String           // UUID
    var transactionTime: String         // Timestamp of transaction e.g. 2020-05-10 09:22:11
}
