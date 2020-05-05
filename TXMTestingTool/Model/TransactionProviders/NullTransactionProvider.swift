//
//  NullTransactionProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation


struct NullTransactionProvider: Provider {
    var defaultFileName = ""

    func provide(_ transactions: [Transaction], merchant: Agent, paymentProvider: PaymentAgent) throws -> String {
        return ""
    }
}
