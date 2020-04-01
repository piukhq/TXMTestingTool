//
//  HarveyNicholsTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 01/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct HNCard: Codable {
    var first6: String
    var last4: String
    var expiry: String
    var scheme: String
}

struct HNTransaction: Codable {
    var altId: String
    var card: HNCard
}

struct HNRootObject: Codable {
    var transactions: [HNTransaction]
}

struct HarveyNicholsTransactionProvider: TransactionProvider {
    func provide(_ transactions: [Transaction]) throws -> String {
        var rootObject = HNRootObject(transactions: [])

        for transaction in transactions {
            rootObject.transactions.append(
                HNTransaction(
                    altId: "",
                    card: HNCard(
                        first6: transaction.firstSix,
                        last4: transaction.lastFour,
                        expiry: "0",
                        scheme: "AMEX"
                    )
                )
            )
        }

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(rootObject)
        return String(data: data, encoding: .utf8)!
    }
}
