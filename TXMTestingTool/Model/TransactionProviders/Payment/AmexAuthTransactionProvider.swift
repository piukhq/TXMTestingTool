//
//  AmexAuthTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 11/05/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct AmexAuthTransactionProvider: Provider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: Agent, paymentProvider: PaymentAgent) throws -> String {
        let amexTransactions = transactions.map {
            AmexAuthTransaction(
                transactionId: UUID().uuidString,  // Generate UUID
                offerId: $0.settlementKey,         // settlement_key - not sure if correct but use
                transactionTime: dateFormatter.string(from: $0.date),
                transactionAmount: Decimal($0.amount) / 100,
                cmAlias: $0.cardToken,
                mid: $0.mid
            )
        }
        
        let data = try jsonEncoder.encode(amexTransactions)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Properties

    var defaultFileName = "amex-auth.json"

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
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
    var transactionId: String
    var offerId: String
    var transactionTime: String
    var transactionAmount: Decimal
    var cmAlias: String
    var mid: String
}
