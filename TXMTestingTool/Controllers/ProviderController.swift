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
            defaultFileName: "harvey-nichols-rewards.json",
            transactionProvider: HarveyNicholsTransactionProvider()
        ),
        Provider(
            slug: "iceland-bonus-card",
            prettyName: "Iceland",
            defaultFileName: "iceland-bonus-card.csv",
            transactionProvider: IcelandTransactionProvider()
        ),
        Provider(
            slug: "burger-king-rewards",
            prettyName: "Burger King",
            defaultFileName: "",
            transactionProvider: NullTransactionProvider()
        )
    ]

    let paymentProviders = [
        Provider(
            slug: "amex",
            prettyName: "Amex",
            defaultFileName: "amex.csv",
            transactionProvider: AmexTransactionProvider()
        ),
        Provider(
            slug: "mastercard",
            prettyName: "Mastercard",
            defaultFileName: "mastercard.txt",
            transactionProvider: MastercardTransactionProvider()
        ),
    ]
}
