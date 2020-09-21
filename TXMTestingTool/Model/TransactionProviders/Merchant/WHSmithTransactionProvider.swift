//
//  WHSmithTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 21/09/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation


struct WHSmithTransactionProvider: CSVProvider {
    var columnHeadings: [String] = []

    var delimiter = "|"

    var defaultFileName = "whsmith.csv"

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DDTHH:mm:ss.SSS"
        formatter.timeZone = TimeZone(identifier: "BST")
        return formatter
    }()

    private let cardSchemes = [
        "amex": "AMEX",
        "visa": "VISA",
        "mastercard": "MASTERCARD",
        "bink-payment": "BINK_PAYMENT"
    ]

    func getCardScheme(for paymentProvider: PaymentAgent) throws -> String {
        if let cardScheme = cardSchemes[paymentProvider.slug] {
            return cardScheme
        } else {
            throw ProviderError.unsupportedPaymentProvider(paymentProvider)
        }
    }

    func transactionToColumns(_ transaction: Transaction, merchant: MerchantAgent, paymentProvider: PaymentAgent, sequenceNumber: Int) throws -> [String] {
        [
            transaction.id,
            String.randomDigits(length: 19),
            dateFormatter.string(from: transaction.date),
            String(transaction.date.timeIntervalSince1970),
            transaction.mid,  // todo: replace with store ID
            "WHSmith Reading",
            "",
            "3",
            String(sequenceNumber),
            "",
            "682292",
            "",
            "",
            "2",
            String(format: "%.2f", Double(transaction.amount) / 100),
            "",
            "1",
            transaction.lastFour,
            try getCardScheme(for: paymentProvider),
            "",
            transaction.authCode,
            "***\(transaction.mid.safeSuffix(from: 3))",
            "",
            "GBP",
            "GB",
        ]
    }
}
