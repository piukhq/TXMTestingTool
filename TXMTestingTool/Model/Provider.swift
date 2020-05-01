//
//  Provider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 01/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

protocol Provider {
    func provide(_ transactions: [Transaction], merchant: Agent, paymentProvider: PaymentProvider) throws -> String
}

// MARK: - Helpers

enum ProviderError: Error {
    case unsupportedPaymentProvider(Agent)
    case memoryStreamReadError
    case csvDecodeError
}

typealias WidthField = (String, Int)
