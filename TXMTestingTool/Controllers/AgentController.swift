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
        Agent(
            slug: "amex",
            prettyName: "Amex",
            defaultFileName: "amex.csv",
            transactionProvider: AmexTransactionProvider()
        ),
        Agent(
            slug: "mastercard",
            prettyName: "Mastercard",
            defaultFileName: "mastercard.txt",
            transactionProvider: MastercardTransactionProvider()
        ),
        Agent(
            slug: "visa",
            prettyName: "Visa",
            defaultFileName: "visa.txt",
            transactionProvider: VisaTransactionProvider()
        ),
    ]
}
