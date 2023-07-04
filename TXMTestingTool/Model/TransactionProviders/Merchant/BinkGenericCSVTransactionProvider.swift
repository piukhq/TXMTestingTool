//
//  BinkGenericSFTPTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 03/07/2023.
//  Copyright © 2023 Bink. All rights reserved.
//

import Foundation
import CSV

struct BinkGenericCSVTransactionProvider: CSVProvider {

    // MARK: - Properties
    
    var hasMID: Bool
    var hasFirstSix: Bool

    var defaultFileName = "transactions.csv"

    var delimiter = ","

    var columnHeadings = [
        "transaction_id",
        "payment_card_type",
        "payment_card_first_six",
        "payment_card_last_four",
        "amount",
        "currency_code",
        "auth_code",
        "date",
        "merchant_identifier",
        "retailer_location_id",
        "transaction_data",
        "customer_id",
    ]

    private let dateFormatter = ISO8601DateFormatter()

    // MARK: - Supporting Functions

    func transactionToColumns(_ transaction: Transaction, merchant: MerchantAgent, paymentProvider: PaymentAgent, sequenceNumber: Int) throws -> [String] {
        [
            transaction.id,
            paymentProvider.slug,
            hasFirstSix ? transaction.firstSix : "",
            transaction.lastFour,
            "\(Double(transaction.amount) / 100)",
            "GBP",
            transaction.authCode,
            dateFormatter.string(from: transaction.date),
            hasMID ? transaction.mid : "",
            transaction.storeID,
            "",  // transaction data
            "",  // customer ID
        ]
    }

}
