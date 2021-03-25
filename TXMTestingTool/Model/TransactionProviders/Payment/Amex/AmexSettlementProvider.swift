//
//  AmexSettlementProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 23/03/2021.
//  Copyright © 2021 Bink. All rights reserved.
//

import Foundation

struct AmexSettlementProvider: Provider {
    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        let amexTransactions = transactions.map {
            AmexTransaction(
                partnerId: "AADP0050",
                recordId: "\($0.id)AADP00400",
                offerId: "0",
                transactionDate: dateFormatter.string(from: $0.date),
                transactionId: $0.id,
                transactionAmount: String(format: "%.2f", Double($0.amount) / 100),
                approvalCode: $0.authCode,
                currencyCode: "840",
                cardToken: $0.cardToken,
                merchantNumber: $0.mid,
                dpan: "\($0.firstSix)XXXXX\($0.lastFour)"
            )
        }

        let data = try jsonEncoder.encode(amexTransactions)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Properties

    var defaultFileName = "amex-settlement.json"

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
}

// MARK: - JSON Codables

struct AmexTransaction: Codable {
    var partnerId: String
    var recordId: String
    var offerId: String
    var transactionDate: String
    var transactionId: String
    var transactionAmount: String
    var approvalCode: String
    var currencyCode: String
    var cardToken: String
    var merchantNumber: String
    var dpan: String
}
