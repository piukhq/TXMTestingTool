//
//  MastercardTGX2SettlementProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct MastercardTGX2SettlementProvider: Provider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        var lines = [String]()
        lines.append(makeHeader())
        lines.append(contentsOf: transactions.map { makeTransactionRow($0, merchant: merchant) })
        lines.append(makeTrailer(recordCount: transactions.count))
        return lines.joined(separator: "\n")
    }

    // MARK: - Properties

    var defaultFileName = "mastercard-tgx2-settlement.txt"

    private let headerFields = [
        FixedWidthField(name: "record_type", start: 0, length: 1),
        FixedWidthField(name: "record_date", start: 1, length: 8),
        FixedWidthField(name: "record_time", start: 9, length: 6),
        FixedWidthField(name: "member_ica", start: 15, length: 6),
        FixedWidthField(name: "file_name", start: 21, length: 50),
        FixedWidthField(name: "filler", start: 71, length: 779)
    ]

    private let detailFields = [
        FixedWidthField(name: "record_type", start: 0, length: 1),
        FixedWidthField(name: "record_date", start: 1, length: 8),
        FixedWidthField(name: "issuer_ica", start: 9, length: 6),
        FixedWidthField(name: "acquirer_ica", start: 15, length: 6),
        FixedWidthField(name: "bank_customer_number", start: 21, length: 30),
        FixedWidthField(name: "bank_account_number", start: 51, length: 30),
        FixedWidthField(name: "bank_product_code", start: 81, length: 20),
        FixedWidthField(name: "transaction_type", start: 101, length: 1),
        FixedWidthField(name: "transaction_date", start: 102, length: 8),
        FixedWidthField(name: "mcc", start: 110, length: 4),
        FixedWidthField(name: "merchant_dba_name", start: 114, length: 22),
        FixedWidthField(name: "merchant_address", start: 136, length: 30),
        FixedWidthField(name: "merchant_city", start: 166, length: 30),
        FixedWidthField(name: "merchant_postal_code", start: 196, length: 10),
        FixedWidthField(name: "merchant_state_province", start: 206, length: 2),
        FixedWidthField(name: "merchant_country", start: 208, length: 3),
        FixedWidthField(name: "merchant_phone_number", start: 211, length: 16),
        FixedWidthField(name: "transaction_amount", start: 227, length: 12),
        FixedWidthField(name: "acquirer_region", start: 239, length: 5),
        FixedWidthField(name: "issuer_region", start: 244, length: 5),
        FixedWidthField(name: "issuer_region", start: 249, length: 3),
        FixedWidthField(name: "issuer_country", start: 252, length: 3),
        FixedWidthField(name: "merchant_mcc_group", start: 255, length: 2),
        FixedWidthField(name: "mcc_classification", start: 257, length: 3),
        FixedWidthField(name: "product", start: 260, length: 3),
        FixedWidthField(name: "debit_switch", start: 263, length: 1),
        FixedWidthField(name: "acquirring_reference_number", start: 264, length: 11),
        FixedWidthField(name: "recurring_payments_flag", start: 275, length: 1),
        FixedWidthField(name: "bank_promotion_field", start: 276, length: 50),
        FixedWidthField(name: "item_description", start: 326, length: 40),
        FixedWidthField(name: "selling_channel", start: 366, length: 10),
        FixedWidthField(name: "store_number", start: 376, length: 10),
        FixedWidthField(name: "store_division", start: 386, length: 10),
        FixedWidthField(name: "product_line", start: 396, length: 10),
        FixedWidthField(name: "item_code", start: 406, length: 15),
        FixedWidthField(name: "item_sku", start: 421, length: 15),
        FixedWidthField(name: "offer_type", start: 436, length: 5),
        FixedWidthField(name: "exception_id", start: 441, length: 4),
        FixedWidthField(name: "client_transaction_code", start: 445, length: 5),
        FixedWidthField(name: "transaction_source_code", start: 450, length: 1),
        FixedWidthField(name: "merchant_id", start: 451, length: 15),
        FixedWidthField(name: "account_reference_id", start: 466, length: 20),
        FixedWidthField(name: "mrs_reserved", start: 486, length: 14),
        FixedWidthField(name: "location_id", start: 500, length: 12),
        FixedWidthField(name: "aggregate_merchant_id", start: 512, length: 6),
        FixedWidthField(name: "de_4_transaction_amount", start: 518, length: 12),
        FixedWidthField(name: "de_5_settlement_amount", start: 530, length: 12),
        FixedWidthField(name: "de_6_billing_amount", start: 542, length: 12),
        FixedWidthField(name: "txn_amount_currency_code", start: 554, length: 3),
        FixedWidthField(name: "settlement_amt_currency_code", start: 557, length: 3),
        FixedWidthField(name: "billing_amount_currency_code", start: 560, length: 3),
        FixedWidthField(name: "transaction_time", start: 563, length: 4),
        FixedWidthField(name: "authorization_code", start: 567, length: 6),
        FixedWidthField(name: "base_points_accrued_sign", start: 573, length: 1),
        FixedWidthField(name: "base_points_accrued", start: 574, length: 12),
        FixedWidthField(name: "promotion_points_accrued_base_sign", start: 586, length: 1),
        FixedWidthField(name: "promotion_points_accrued_base", start: 587, length: 12),
        FixedWidthField(name: "promotion_points_accrued_bonus_sign", start: 599, length: 1),
        FixedWidthField(name: "promotion_points_accrued_bonus", start: 600, length: 12),
        FixedWidthField(name: "bank_product_name", start: 612, length: 120),
        FixedWidthField(name: "transaction_sequence_number", start: 732, length: 13),
        FixedWidthField(name: "fr_posting_date", start: 745, length: 8),
        FixedWidthField(name: "process_date", start: 753, length: 8),
        FixedWidthField(name: "banknet_reference_number", start: 761, length: 9),
        FixedWidthField(name: "customer_user_defined_1", start: 770, length: 40),
        FixedWidthField(name: "account_user_defined_1", start: 810, length: 40)
    ]

    private let trailerFields = [
        FixedWidthField(name: "record_type", start: 0, length: 1),
        FixedWidthField(name: "record_date", start: 1, length: 8),
        FixedWidthField(name: "record_time", start: 9, length: 6),
        FixedWidthField(name: "member_ica", start: 15, length: 6),
        FixedWidthField(name: "file_name", start: 21, length: 50),
        FixedWidthField(name: "record_count", start: 71, length: 9),
        FixedWidthField(name: "filler", start: 80, length: 770)
    ]

    private let headerFieldGenerators = [
        "record_type": formatHeaderRecordType,
        "record_date": formatHeaderDate,
        "record_time": formatHeaderTime,
        "file_name": formatHeaderFileName,
    ]

    // based on the table in MER-1031
    private let detailFieldGenerators = [
        "record_type": formatDetailRecordType,
        "merchant_id": formatMerchantID,
        "de_4_transaction_amount": formatAmount,
        "transaction_date": formatDate,
        "transaction_time": formatTime,
        "bank_customer_number": formatToken,
        "banknet_reference_number": formatTransactionID,
        "authorization_code": formatAuthCode,
    ]

    private let trailerFieldGenerators = [
        "record_type": formatTrailerRecordType,
        "record_date": formatHeaderDate,    // trailer uses the same date, time, and file name format as header
        "record_time": formatHeaderTime,
        "file_name": formatHeaderFileName,
    ]

    private typealias FieldGenerator = (MastercardTGX2SettlementProvider) -> () -> String
    private typealias DetailFieldGenerator = (MastercardTGX2SettlementProvider) -> (Transaction) -> String

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "HHmm"
        return formatter
    }()

    private let headerTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "BST")
        formatter.dateFormat = "HHmmss"
        return formatter
    }()

    // MARK: - Supporting Functions

    private func generateFieldValue(_ field: FixedWidthField, with generators: [String: FieldGenerator]) -> String {
        if let fieldGenerator = generators[field.name] {
            return fieldGenerator(self)()
        } else {
            return " "
        }
    }

    private func generateFieldValue(_ field: FixedWidthField, with generators: [String: DetailFieldGenerator], transaction: Transaction) -> String {
        if let fieldGenerator = generators[field.name] {
            return fieldGenerator(self)(transaction)
        } else {
            return " "
        }
    }

    private func join(_ fields: [FixedWidthField], generators: [String: FieldGenerator]) -> String {
        let columns = fields.map { (field) -> String in
            let value = generateFieldValue(field, with: generators)
            return value.padding(toLength: field.length, withPad: " ", startingAt: 0)
        }

        return columns.joined(separator: "")
    }

    private func join(_ fields: [FixedWidthField], generators: [String: DetailFieldGenerator], transaction: Transaction) -> String {
        let columns = fields.map { (field) -> String in
            let value = generateFieldValue(field, with: generators, transaction: transaction)
            return value.padding(toLength: field.length, withPad: " ", startingAt: 0)
        }

        return columns.joined(separator: "")
    }

    func makeHeader() -> String {
        return join(headerFields, generators: headerFieldGenerators)
    }

    func makeTransactionRow(_ transaction: Transaction, merchant: Agent) -> String {
        return join(detailFields, generators: detailFieldGenerators, transaction: transaction)
    }

    func makeTrailer(recordCount: Int) -> String {
        return join(trailerFields, generators: trailerFieldGenerators)
    }
}

// MARK: - Header Record Field Generators

extension MastercardTGX2SettlementProvider {
    private func formatHeaderRecordType() -> String {
        return "1"
    }

    private func formatHeaderDate() -> String {
        return dateFormatter.string(from: Date())
    }

    private func formatHeaderTime() -> String {
        return headerTimeFormatter.string(from: Date())
    }

    private func formatHeaderFileName() -> String {
        return defaultFileName  // not always correct, but doesn't really matter
    }
}

// MARK: - Detail Record Field Generators

extension MastercardTGX2SettlementProvider {
    private func formatDetailRecordType(_: Transaction) -> String {
        return "2"
    }

    private func formatMerchantID(_ tx: Transaction) -> String {
        return tx.mid
    }

    private func formatAmount(_ tx: Transaction) -> String {
        return String(format: "%013.2f", Double(tx.amount) / 100)
    }

    private func formatDate(_ tx: Transaction) -> String {
        return dateFormatter.string(from: tx.date)
    }

    private func formatTime(_ tx: Transaction) -> String {
        return timeFormatter.string(from: tx.date)
    }

    private func formatToken(_ tx: Transaction) -> String {
        return tx.cardToken
    }

    private func formatTransactionID(_ tx: Transaction) -> String {
        return tx.id
    }

    private func formatAuthCode(_ tx: Transaction) -> String {
        return tx.authCode
    }
}

// MARK: - Trailer Record Field Generators

extension MastercardTGX2SettlementProvider {
    private func formatTrailerRecordType() -> String {
        return "3"
    }
}

