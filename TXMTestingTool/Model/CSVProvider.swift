//
//  CSVProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 15/09/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation
import CSV

protocol CSVProvider: Provider {
    var columnHeadings: [String] { get }
    var delimiter: String { get }

    func transactionToColumns(_ transaction: Transaction, merchant: MerchantAgent, paymentProvider: PaymentAgent, sequenceNumber: Int) throws -> [String]
}

extension CSVProvider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        let csv = try CSVWriter(stream: .toMemory(), delimiter: delimiter)
        try csv.write(row: columnHeadings)
        for (sequenceNumber, transaction) in transactions.enumerated() {
            let columns = try transactionToColumns(transaction, merchant: merchant, paymentProvider: paymentProvider, sequenceNumber: sequenceNumber)
            try csv.write(row: columns)
        }
        csv.stream.close()

        return try getCSVString(from: csv)
    }

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
}
