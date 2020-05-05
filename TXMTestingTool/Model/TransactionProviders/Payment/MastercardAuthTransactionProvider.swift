//
//  MastercardAuthTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct MastercardAuthTransactionProvider: Provider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: Agent, paymentProvider: PaymentAgent) throws -> String {
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

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(mcaTransactions)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Properties

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
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
