//
//  AmexTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation


struct AmexTransactionProvider: TransactionProvider {
    func provide(_ transactions: [Transaction]) throws -> String {
        return "<\(transactions.count) amex transactions go here>"
    }
}
