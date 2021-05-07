//
//  Provider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 01/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

protocol Provider {
    var defaultFileName: String { get }

    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String
}

// MARK: - Helpers

enum ProviderError: Error {
    case unsupportedPaymentProvider(PaymentAgent)
    case memoryStreamReadError
    case csvDecodeError
}

// Legacy fixed-width file field system used in legacy Visa and MC providers. Will be removed when they are.
typealias WidthField = (String, Int)

// Newer fixed-width file field system used in TGX2 MC provider. Will become the only option when the above is removed.
struct FixedWidthField {
    var name: String
    var start: Int
    var length: Int
}
