//
//  VisaTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 07/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct VisaTransactionProvider: Provider {
    
    // MARK: - Protocol Implementation
    
    func provide(_ transactions: [Transaction], merchant: Agent, paymentProvider: PaymentAgent) throws -> String {
        var lines = [String]()
        lines.append(makeHeader())
        lines.append(contentsOf: transactions.map { makeTransactionRow($0, merchant: merchant) })
        lines.append(makeTrailer(recordCount: transactions.count))
        return lines.joined(separator: "\n")
    }
    
    // MARK: - Properties

    var defaultFileName = "visa-settled.txt"
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hhmm"
        return formatter
    }()

    // MARK: - Supporting Functions
    
    func join(_ parts: WidthField...) -> String {
        let columns = parts.map { (value, length) in value.padding(toLength: length, withPad: " ", startingAt: 0) }
        return columns.joined(separator: "")
    }

    func makeHeader() -> String {
        let now = dateFormatter.string(from: Date())
        return join(
            ("00", 2),                                          // record type
            ("00", 2),                                          // record subtype
            ("TAQC", 6),                                        // sender/source ID
            ("LOYANG", 6),                                      // receiver/destination ID
            ("Standard Transaction Extract", 255),              // file description
            (now, 8),                                           // file creation date
            ("", 2),                                            // file control number
            ("2.0", 4),                                         // file format version
            ("P", 1),                                           // test file indicator
            (now, 8),                                           // content start date
            (now, 8),                                           // content end date
            ("", 670)                                           // filler
        )
    }

    func makeTransactionRow(_ transaction: Transaction, merchant: Agent) -> String {
        let date = dateFormatter.string(from: transaction.date)
        let timestamp = timeFormatter.string(from: transaction.date)
        return join(
            ("16", 2),                                          // record type
            ("01", 2),                                          // record subtype
            ("3G", 2),                                          // promotion type
            ("B16LOYANPVLOYANGSAUG16AVD", 25),                  // promotion code
            ("05", 2),                                          // transaction code
            (String(format: "%015d", transaction.amount), 15),
            ("", 21),                                           // filler
            ("LOYANG", 6),                                      // project sponsor ID
            ("LOYANG", 6),                                      // promotion group ID
            ("", 30),                                           // padding for 5411
            ("5411", 4),                                        // unknown
            (merchant.slug.uppercased(), 25),
            ("ASCOT", 13),                                      // merchant city
            ("--", 2),                                          // merchant state
            ("00000", 9),                                       // merchant zip
            (" 826", 4),                                        // merchant country
            (date, 8),
            ("", 18),                                           // filler
            (transaction.mid, 15),
            (date, 8),
            (timestamp, 4),
            ("", 16),                                           // filler
            (date, 8),
            (String(format: "%014d", 1), 14),                   // transaction sequence ID
            ("", 108),                                          // filler
            ("GBP", 3),                                         // country currency code
            (String(format: "%015d", transaction.amount), 15),
            ("GBP", 3),                                         // acquirer currency code
            ("", 44),                                           // filler
            (String.randomDigits(length: 15), 15),              // transaction ID
            ("", 22),                                           // filler
            (String.randomDigits(length: 6), 6),                // auth code
            ("", 89),                                           // filler
            (transaction.cardToken, 25),
            (timestamp, 4),
            ("", 407)                                           // filler
        )
    }
    
    func makeTrailer(recordCount: Int) -> String {
        join(
            ("99", 2),                                          // record type
            ("99", 2),                                          // record subtype
            ("", 10),                                           // filler
            (String(format: "%010d", recordCount), 10),         // record count
            ("", 10),                                           // filler
            ("", 966)                                           // filler
        )
    }
}
