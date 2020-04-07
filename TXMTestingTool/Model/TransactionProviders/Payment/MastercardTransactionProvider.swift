//
//  MastercardTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct MastercardTransactionProvider: Provider {
    
    // MARK: - Protocol Implementation
    
    func provide(_ transactions: [Transaction], merchant: Agent, paymentProvider: Agent) throws -> String {
        var lines = [String]()
        lines.append(makeHeader())
        lines.append(contentsOf: transactions.map { makeTransactionRow($0, merchant: merchant) })
        lines.append(makeTrailer(recordCount: transactions.count))
        return lines.joined(separator: "\n")
    }
    
    // MARK: - Properties

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMDD"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hhmmss"
        return formatter
    }()
    
    // MARK: - Supporting Functions

    private func join(_ parts: WidthField...) -> String {
        let columns = parts.map { (value, length) in value.padding(toLength: length, withPad: " ", startingAt: 0) }
        return columns.joined(separator: "")
    }

    func makeHeader() -> String {
        let now = Date()
        return join(
            ("H", 1),                               // header record
            (dateFormatter.string(from: now), 8),
            (timeFormatter.string(from: now), 6),
            ("00000017597", 11),                    // member ICA
            ("", 174)                               // filler
        )
    }

    func makeTransactionRow(_ transaction: Transaction, merchant: Agent) -> String {
        join(
            ("D", 1),                                                           // data record
            (String(format: "%013d", 1), 13),                                   // tx sequence number
            ("", 19),                                                           // bank account number
            (String(format: "%013.2f", Double(transaction.amount) / 100), 13),
            (dateFormatter.string(from: transaction.date), 8),
            (merchant.slug.uppercased(), 60),
            (transaction.mid, 22),
            (String(format: "%09d", 1), 9),                                     // location ID
            (String(format: "%06d", 1), 6),                                     // issuer ICA code
            ("0000", 4),                                                        // transaction time
            // TODO: settlement key goes here
            ("", 9),                                                            // banknet ref number
            (transaction.cardToken, 30),                                        // bank customer number
            (String(format: "%06d", 1), 6)                                      // aggregate merchant ID
        )
    }
    
    func makeTrailer(recordCount: Int) -> String {
        join(
            ("T", 1),                                       // trailer record
            (String(format: "%012d", recordCount), 12),     // record count
            ("00000017597", 11),                            // member ICA
            ("", 176)                                       // filler
        )
    }
}
