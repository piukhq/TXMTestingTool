//
//  WasabiTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 12/08/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation
import CSV

struct WasabiTransactionProvider: CSVProvider {

    // MARK: - Properties

    var defaultFileName = "wasabi.csv"

    var delimiter = ","

    var columnHeadings = [
        "Store No_",
        "Entry No_",
        "Transaction No_",
        "Tender Type",
        "Amount",
        "Card Number",
        "Card Type Name",
        "Auth_code",
        "Authorisation Ok",
        "Date",
        "Time",
        "EFT Merchant No_",
        "Receipt No_"
    ]

    private let cardTypeNames = [
        "amex": "American Express",
        "visa": "Visa",
        "mastercard": "Mastercard",
        "bink-payment": "Bink-Payment"
    ]

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    // MARK: - Supporting Functions

    func getCardTypeName(for paymentProvider: PaymentAgent) throws -> String {
        if let cardTypeName = cardTypeNames[paymentProvider.slug] {
            return cardTypeName
        } else {
            throw ProviderError.unsupportedPaymentProvider(paymentProvider)
        }
    }

    func transactionToColumns(_ transaction: Transaction, merchant: MerchantAgent, paymentProvider: PaymentAgent, sequenceNumber: Int) throws -> [String] {
        [
            "A076",  // store number
            "\(sequenceNumber)", // entry number
            transaction.id, // transaction number
            "3",    // tender type
            "\(Double(transaction.amount) / 100)",
            "\(transaction.firstSix)******\(transaction.lastFour)",
            try getCardTypeName(for: paymentProvider),
            transaction.authCode,
            "1",
            dateFormatter.string(from: transaction.date),
            timeFormatter.string(from: transaction.date),
            transaction.mid,
            transaction.id,
        ]
    }

}
