//
//  IcelandTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation
import CSV

struct IcelandTransactionProvider: CSVProvider {

    // MARK: - Properties

    var defaultFileName = "iceland-bonus-card.csv"

    var delimiter = ","

    var columnHeadings = [
        "TransactionCardFirst6",
        "TransactionCardLast4",
        "TransactionCardExpiry",
        "TransactionCardSchemeId",
        "TransactionCardScheme",
        "TransactionStore_Id",
        "TransactionTimestamp",
        "TransactionAmountValue",
        "TransactionAmountUnit",
        "TransactionCashbackValue",
        "TransactionCashbackUnit",
        "TransactionId",
        "TransactionAuthCode"
    ]

    private let cardSchemeIds = [
        "amex": "1",
        "visa": "2",
        "mastercard": "3",
        "bink-payment": "6"
    ]

    private let cardSchemes = [
        "amex": "Amex",
        "visa": "Visa",
        "mastercard": "MasterCard/MasterCard One",
        "bink-payment": "Bink-Payment"
    ]

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    // MARK: - Supporting Functions

    func getCardSchemeId(for paymentProvider: PaymentAgent) throws -> String {
        if let cardSchemeId = cardSchemeIds[paymentProvider.slug] {
            return cardSchemeId
        } else {
            throw ProviderError.unsupportedPaymentProvider(paymentProvider)
        }
    }

    func getCardScheme(for paymentProvider: PaymentAgent) throws -> String {
        if let cardScheme = cardSchemes[paymentProvider.slug] {
            return cardScheme
        } else {
            throw ProviderError.unsupportedPaymentProvider(paymentProvider)
        }
    }

    func transactionToColumns(_ transaction: Transaction, merchant: MerchantAgent, paymentProvider: PaymentAgent, sequenceNumber: Int) throws -> [String] {
        [
            transaction.firstSix,
            transaction.lastFour,
            "01/80",
            try getCardSchemeId(for: paymentProvider),
            try getCardScheme(for: paymentProvider),
            transaction.mid,
            dateFormatter.string(from: transaction.date),
            String(format: "%.2f", Double(transaction.amount) / 100),
            "GBP",
            ".00",
            "GBP",
            UUID().uuidString,
            transaction.authCode
        ]
    }
}
