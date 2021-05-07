//
//  HarveyNicholsTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 01/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct HarveyNicholsTransactionProvider: Provider {

    // MARK: - Properties

    var defaultFileName = "harvey-nichols-rewards.json"

    private let cardSchemes = [
        "amex": "AMEX",
        "visa": "VISA",
        "mastercard": "MASTERCARD",
    ]

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        var rootObject = HNRootObject(transactions: [])

        for transaction in transactions {
            rootObject.transactions.append(
                HNTransaction(
                    altId: "",
                    card: HNCard(
                        first6: transaction.firstSix,
                        last4: transaction.lastFour,
                        expiry: "0",
                        scheme: try getCardScheme(for: paymentProvider)
                    ),
                    amount: HNAmount(
                        value: Decimal(transaction.amount) / 100,
                        unit: "GBP"
                    ),
                    storeId: transaction.mid,   // TODO: can we simulate HN store IDs properly?
                    timestamp: dateFormatter.string(from: transaction.date),
                    id: UUID().uuidString,
                    authCode: "00\(transaction.authCode)"
                )
            )
        }

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(rootObject)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Supporting Functions

    func getCardScheme(for paymentProvider: PaymentAgent) throws -> String {
        if let cardScheme = cardSchemes[paymentProvider.slug] {
            return cardScheme
        } else {
            throw ProviderError.unsupportedPaymentProvider(paymentProvider)
        }
    }
}


// MARK: - JSON Codables

struct HNRootObject: Codable {
    var transactions: [HNTransaction]
}

struct HNTransaction: Codable {
    var altId: String
    var card: HNCard
    var amount: HNAmount
    var storeId: String
    var timestamp: String
    var id: String
    var authCode: String
}

struct HNCard: Codable {
    var first6: String
    var last4: String
    var expiry: String
    var scheme: String

    private enum CodingKeys: String, CodingKey {
        case first6 = "first_6"
        case last4 = "last_4"
        case expiry
        case scheme
    }
}

struct HNAmount: Codable {
    var value: Decimal
    var unit: String
}
