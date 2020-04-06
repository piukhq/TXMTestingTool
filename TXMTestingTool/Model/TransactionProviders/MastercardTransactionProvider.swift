//
//  MastercardTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation


struct MastercardTransactionProvider: TransactionProvider {
    func provide(_ transactions: [Transaction], merchant: Provider, paymentProvider: Provider) throws -> String {
        return "<\(transactions.count) mastercard transactions go here>"
    }
}
