//
//  TransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 01/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

protocol TransactionProvider {
    func provide(_ transactions: [Transaction], merchant: Provider, paymentProvider: Provider) throws -> String
}
