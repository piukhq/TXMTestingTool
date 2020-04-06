//
//  NullTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation


struct NullTransactionProvider: TransactionProvider {
    func provide(_ transactions: [Transaction], merchant: Provider, paymentProvider: Provider) throws -> String {
        return ""
    }
}
