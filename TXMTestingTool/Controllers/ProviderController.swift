//
//  ProviderController.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation


class ProviderController {
    static let shared = ProviderController()

    let merchants = [
        Provider(
            slug: "harvey-nichols-rewards",
            prettyName: "Harvey Nichols",
            transactionProvider: HarveyNicholsTransactionProvider()
        ),
        Provider(
            slug: "iceland-bonus-card",
            prettyName: "Iceland",
            transactionProvider: IcelandTransactionProvider()
        ),
        Provider(
            slug: "burger-king-rewards",
            prettyName: "Burger King",
            transactionProvider: NullTransactionProvider()
        )
    ]

    let paymentProviders = [
        Provider(
            slug: "amex",
            prettyName: "Amex",
            transactionProvider: AmexTransactionProvider()
        ),
        Provider(
            slug: "mastercard",
            prettyName: "Mastercard",
            transactionProvider: MastercardTransactionProvider()
        ),
    ]
}
