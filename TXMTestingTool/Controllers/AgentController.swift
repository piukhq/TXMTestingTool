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
            slug: "burger-king-rewards",
            prettyName: "Burger King"
        ),
        Agent(
            slug: "fatface",
            prettyName: "FatFace"
        ),
        Agent(
            slug: "harvey-nichols-rewards",
            prettyName: "Harvey Nichols",
            transactionProvider: HarveyNicholsTransactionProvider()
        ),
        Agent(
            slug: "iceland-bonus-card",
            prettyName: "Iceland",
            transactionProvider: IcelandTransactionProvider()
        )
    ]

    let paymentProviders = [
        PaymentAgent(
            slug: "amex",
            prettyName: "Amex",
            settledTransactionProvider: AmexSettlementProvider(),
            authTransactionProvider: AmexAuthProvider()
        ),
        PaymentAgent(
            slug: "mastercard",
            prettyName: "Mastercard",
            settledTransactionProvider: MastercardSettlementProvider(),
            authTransactionProvider: MastercardAuthProvider()
        ),
        PaymentAgent(
            slug: "visa",
            prettyName: "Visa (Classic)",
            settledTransactionProvider: VisaClassicSettlementProvider()
        ),
        PaymentAgent(
            slug: "visa",
            prettyName: "Visa (VOP)",
            settledTransactionProvider: VisaClassicSettlementProvider()
        )
    ]
}
