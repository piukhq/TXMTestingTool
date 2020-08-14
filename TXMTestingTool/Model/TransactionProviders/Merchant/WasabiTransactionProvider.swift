//
//  WasabiTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 12/08/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation
import CSV

struct WasabiTransactionProvider: Provider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        let csv = try CSVWriter(stream: .toMemory())
        try csv.write(row: columnHeadings)
        for (index, transaction) in transactions.enumerated() {
            let columns = try transactionToColumns(transaction, paymentProvider: paymentProvider, index: index)
            try csv.write(row: columns)
        }
        csv.stream.close()

        return try getCSVString(from: csv)
    }

    // MARK: - Properties

    var defaultFileName = "wasabi.csv"

    private let cardTypeNames = [
        "amex": "American Express",
        "visa": "Visa",
        "mastercard": "Mastercard",
        "bink-payment": "Bink-Payment"
    ]

    private let columnHeadings = [
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

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    // MARK: - Supporting Functions

    func getCSVString(from csv: CSVWriter) throws -> String {
        guard let csvData = csv.stream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
            throw ProviderError.memoryStreamReadError
        }

        guard let csvString = String(data: csvData, encoding: .utf8) else {
            throw ProviderError.csvDecodeError
        }

        return csvString
    }

    func getCardTypeName(for paymentProvider: PaymentAgent) throws -> String {
        if let cardTypeName = cardTypeNames[paymentProvider.slug] {
            return cardTypeName
        } else {
            throw ProviderError.unsupportedPaymentProvider(paymentProvider)
        }
    }

    func transactionToColumns(_ transaction: Transaction, paymentProvider: PaymentAgent, index: Int) throws -> [String] {
        [
            "A076",  // store number
            "\(index)", // entry number
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
