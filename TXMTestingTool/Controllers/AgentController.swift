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
            transactionProvider: HarveyNicholsTransactionProvider()
        ),
        Agent(
            slug: "iceland-bonus-card",
            prettyName: "Iceland",
            transactionProvider: IcelandTransactionProvider()
        ),
        Agent(
            slug: "burger-king-rewards",
            prettyName: "Burger King"
        )
    ]

    let paymentProviders = [
        PaymentAgent(
            slug: "amex",
            prettyName: "Amex",
            settledTransactionProvider: AmexTransactionProvider()
        ),
        PaymentAgent(
            slug: "mastercard",
            prettyName: "Mastercard",
            settledTransactionProvider: MastercardTransactionProvider(),
            authTransactionProvider: MastercardAuthTransactionProvider()
        ),
        PaymentAgent(
            slug: "visa",
            prettyName: "Visa",
            settledTransactionProvider: VisaTransactionProvider()
        )
    ]
}
