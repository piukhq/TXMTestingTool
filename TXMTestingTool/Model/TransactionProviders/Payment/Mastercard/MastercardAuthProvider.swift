//
//  MastercardAuthProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct MastercardAuthProvider: Provider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        let mcaTransactions = transactions.map {
            MCATransaction(
                thirdPartyID: String($0.settlementKey.prefix(9)),
                time: dateFormatter.string(from: $0.date),
                amount: Decimal($0.amount) / 100,
                currencyCode: "GBP",
                paymentCardToken: $0.cardToken,
                mid: $0.mid
            )
        }

        let data = try jsonEncoder.encode(mcaTransactions)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Properties

    var defaultFileName = "mastercard-auth.json"

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "CDT")
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

struct MCATransaction: Codable {
    var thirdPartyID: String
    var time: String
    var amount: Decimal
    var currencyCode: String
    var paymentCardToken: String
    var mid: String
}
