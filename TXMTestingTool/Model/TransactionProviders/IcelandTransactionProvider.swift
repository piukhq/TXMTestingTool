//
//  IcelandTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation
import CSV


struct IcelandTransactionProvider: TransactionProvider {
    enum ProviderError: Error {
        case unsupportedPaymentProvider(Provider)
        case memoryStreamReadError
        case csvDecodeError
    }

    let cardSchemeIds = [
        "amex": "1",
        "visa": "2",
        "mastercard": "3",
        "bink-payment": "6"
    ]

    let columnHeadings = [
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

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD hh:mm:ss"
        return formatter
    }

    func randomDigitString(length: Int) -> String {
        let digits = "0123456789"
        return String((0..<length).map { _ in digits.randomElement() ?? "0" })
    }

    func getCSVString(from csv: CSVWriter) throws -> String {
        guard let csvData = csv.stream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
            throw ProviderError.memoryStreamReadError
        }

        guard let csvString = String(data: csvData, encoding: .utf8) else {
            throw ProviderError.csvDecodeError
        }

        return csvString
    }

    func getCardSchemeId(for paymentProvider: Provider) throws -> String {
        if let cardSchemeId = cardSchemeIds[paymentProvider.slug] {
            return cardSchemeId
        } else {
            throw ProviderError.unsupportedPaymentProvider(paymentProvider)
        }
    }

    func transactionToColumns(_ transaction: Transaction, paymentProvider: Provider) throws -> [String] {
        [
            transaction.firstSix,
            transaction.lastFour,
            "01/80",
            try getCardSchemeId(for: paymentProvider),
            paymentProvider.slug.capitalized,
            transaction.mid,
            dateFormatter.string(from: transaction.date),
            String(format: "%.2f", Double(transaction.amount) / 100),
            "GBP",
            ".00",
            "GBP",
            UUID().uuidString,
            randomDigitString(length: 6)
        ]
    }

    func provide(_ transactions: [Transaction], merchant: Provider, paymentProvider: Provider) throws -> String {
        let csv = try CSVWriter(stream: .toMemory())
        try csv.write(row: columnHeadings)
        for transaction in transactions {
            let columns = try transactionToColumns(transaction, paymentProvider: paymentProvider)
            try csv.write(row: columns)
        }
        csv.stream.close()

        return try getCSVString(from: csv)
    }
}
