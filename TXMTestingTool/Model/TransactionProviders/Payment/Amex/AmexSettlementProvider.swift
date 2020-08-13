//
//  AmexSettlementProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct AmexSettlementProvider: Provider {
    
    // MARK: - Protocol Implementation
    
    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        var lines = [String]()
        lines.append(makeHeader())
        lines.append(contentsOf: transactions.map { makeTransactionRow(from: $0) })
        lines.append(makeTrailer(transactionCount: transactions.count))
        return lines.joined(separator: "\n")
    }
    
    // MARK: - Properties

    var defaultFileName = "amex-settled.csv"
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "yyyy-MM-dd-HH.mm.ss"
        return formatter
    }()
    
    // MARK: - Supporting Functions

    private func pipe(_ items: String...) -> String {
        items.joined(separator: "|")
    }

    func makeHeader() -> String {
        pipe(
            "H",                                                                    // header identifier
            dateFormatter.string(from: Date()),
            "0000000001",                                                           // sequence number
            "A2P",                                                                  // from/to
            "03",                                                                   // file type (03 = tlog)
            "AMEX TLOG FILE".padding(toLength: 40, withPad: " ", startingAt: 0),    // file description
            String(repeating: " ", count: 209)                                      // filler
        )
    }
    
    func makeTransactionRow(from transaction: Transaction) -> String {
        pipe(
            "D",                                                                    // detail identifier
            "AADP0050",                                                             // partner id
            UUID().uuidString,                                                      // transaction ID
            dateFormatter.string(from: transaction.date),
            String(format: "%017.2f", Double(transaction.amount) / 100),
            transaction.cardToken.padding(toLength: 200, withPad: " ", startingAt: 0),
            transaction.mid.padding(toLength: 15, withPad: " ", startingAt: 0),
            dateTimeFormatter.string(from: transaction.date),
            "\(transaction.firstSix)XXXXX\(transaction.lastFour)"
        )
    }

    func makeTrailer(transactionCount: Int) -> String {
        pipe(
            "T",                                        // trailer identifier
            "03",                                       // file type (03 = tlog)
            String(format: "%012d", transactionCount),  // record count
            String(repeating: " ", count: 263)          // filler
        )
    }
}
