//
//  AgentController.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

class AgentController {
    static let shared = AgentController()

    let merchants = [
        Agent(
            slug: "harvey-nichols-rewards",
            prettyName: "Harvey Nichols",
            defaultFileName: "harvey-nichols-rewards.json",
            transactionProvider: HarveyNicholsTransactionProvider()
        ),
        Agent(
            slug: "iceland-bonus-card",
            prettyName: "Iceland",
            defaultFileName: "iceland-bonus-card.csv",
            transactionProvider: IcelandTransactionProvider()
        ),
        Agent(
            slug: "burger-king-rewards",
            prettyName: "Burger King",
            defaultFileName: "",
            transactionProvider: NullTransactionProvider()
        )
    ]

    let paymentProviders = [
        PaymentProvider(
            slug: "amex",
            prettyName: "Amex",
            defaultSettledFileName: "amex-settled.csv",
            defaultAuthFilename: "amex-auth.json",
            settledTransactionProvider: AmexTransactionProvider(),
            authTransactionProvider: NullTransactionProvider()
        ),
        PaymentProvider(
            slug: "mastercard",
            prettyName: "Mastercard",
            defaultSettledFileName: "mastercard-settled.txt",
            defaultAuthFilename: "mastercard-auth.json",
            settledTransactionProvider: MastercardTransactionProvider(),
            authTransactionProvider: MastercardAuthTransactionProvider()
        ),
        PaymentProvider(
            slug: "visa",
            prettyName: "Visa",
            defaultSettledFileName: "visa-settled.txt",
            defaultAuthFilename: "visa-auth.json",
            settledTransactionProvider: VisaTransactionProvider(),
            authTransactionProvider: NullTransactionProvider()
        )
    ]
}
