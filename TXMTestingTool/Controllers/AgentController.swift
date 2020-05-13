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
        MerchantAgent("Burger King", slug: "burger-king-rewards", type: .plr),
        MerchantAgent("FatFace", slug: "fatface", type: .plr),
        MerchantAgent("Harvey Nichols", slug: "harvey-nichols-rewards", type: .pll, provider: HarveyNicholsTransactionProvider()),
        MerchantAgent("Iceland", slug: "iceland-bonus-card", type: .pll, provider: IcelandTransactionProvider()),
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
            settledTransactionProvider: VOPTransactionProvider(transactionType: .settlement),
            authTransactionProvider: VOPTransactionProvider(transactionType: .auth)
        )
    ]
}
