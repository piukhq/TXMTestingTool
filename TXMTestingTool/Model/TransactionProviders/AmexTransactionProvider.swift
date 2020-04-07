//
//  AmexTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation


/*
Example output:

H|2020-04-98|0000000001|A2P|03|AMEX TLOG FILE                          |
D|AADP0050|57670B8E-4568-4096-8A31-B7FCDAF20669|2020-04-98|00000000000016.99|token-123 <lots of spaces> |abc123         |2020-04-98-03.48.19|123456XXXXX7890
D|AADP0050|DABCC357-6A4A-4985-8E93-38DB14707C24|2020-04-98|00000000000017.99|token-234 <lots of spaces> |def456         |2020-04-98-03.48.19|234567XXXXX8901
D|AADP0050|36865533-45CE-43A5-B94D-CDC0AF9ED88A|2020-04-98|00000000000018.99|token-345 <lots of spaces> |ghi789         |2020-04-98-03.48.19|345678XXXXX9012
D|AADP0050|EEF28D98-5AB8-49B4-9AAD-40F417A90400|2020-04-98|00000000000019.99|token-456 <lots of spaces> |jkl012         |2020-04-98-03.48.19|456789XXXXX0123
T|03|000000000004|
*/

struct AmexTransactionProvider: TransactionProvider {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }

    var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD-hh.mm.ss"
        return formatter
    }

    func pipe(_ items: String...) -> String {
        items.joined(separator: "|")
    }

    func makeHeader() -> String {
        pipe(
            "H",  // header identifier
            dateFormatter.string(from: Date()),
            "0000000001",  // sequence number
            "A2P",  // from/to
            "03",  // file type (03 = tlog)
            "AMEX TLOG FILE".padding(toLength: 40, withPad: " ", startingAt: 0),  // file description
            String(repeating: " ", count: 209)  // filler
        )
    }

    func makeTrailer(transactionCount: Int) -> String {
        pipe(
            "T",  // trailer identifier
            "03",  // file type (03 = tlog)
            String(format: "%012d", transactionCount),    // record count
            String(repeating: " ", count: 263)  // filler
        )
    }

    func makeTransactionRow(from transaction: Transaction) -> String {
        pipe(
            "D",  // detail identifier
            "AADP0050",  // partner id
            UUID().uuidString,  // transaction ID
            dateFormatter.string(from: transaction.date),
            String(format: "%017.2f", Double(transaction.amount) / 100),
            transaction.cardToken.padding(toLength: 200, withPad: " ", startingAt: 0),
            transaction.mid.padding(toLength: 15, withPad: " ", startingAt: 0),
            dateTimeFormatter.string(from: transaction.date),
            "\(transaction.firstSix)XXXXX\(transaction.lastFour)"
        )
    }

    func provide(_ transactions: [Transaction], merchant: Provider, paymentProvider: Provider) throws -> String {
        var lines = [String]()
        lines.append(makeHeader())
        lines.append(contentsOf: transactions.map { makeTransactionRow(from: $0) })
        lines.append(makeTrailer(transactionCount: transactions.count))
        return lines.joined(separator: "\n")
    }
}
