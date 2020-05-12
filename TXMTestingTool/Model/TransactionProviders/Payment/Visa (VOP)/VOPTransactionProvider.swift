//
//  VOPSettlementProvider.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 11/05/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct VOPTransactionProvider: Provider {

    // MARK: - Protocol Implementation

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        let visaTransactions = transactions.map {
            VOPTransaction(
                withTransaction: $0,
                type: type,
                forMerchant: merchant,
                transactionDateFormatter: dateFormatter,
                merchantPurchaseDateFormatter: localPurchaseDateFormatter
            )
        }

        let data = try jsonEncoder.encode(visaTransactions)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: - Properties

    var defaultFileName: String
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
    }()
    
    private let localPurchaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }()
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
    
    let type: TransactionType
    
    // MARK: - Initialisation
    
    init(transactionType type: TransactionType) {
        self.type = type
        
        switch type {
        case .auth:
            defaultFileName = "visa-vop-auth.json"
        case .settlement:
            defaultFileName = "visa-vop-settled.json"
        }
    }
}
