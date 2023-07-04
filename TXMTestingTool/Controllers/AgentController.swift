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
        MerchantAgent("Harvey Nichols", slug: "harvey-nichols-rewards", type: .pll, provider: HarveyNicholsTransactionProvider()),
        MerchantAgent("Iceland", slug: "iceland-bonus-card", type: .pll, provider: IcelandTransactionProvider()),
        MerchantAgent("Wasabi", slug: "wasabi-club", type: .plr, provider: WasabiTransactionProvider()),
        MerchantAgent("Itsu", slug: "itsu", type: .pll, provider: BinkGenericCSVTransactionProvider(hasMID: false, hasFirstSix: false)),
        MerchantAgent("Spotting Merchant", slug: "spotting-merchant", type: .plr),
    ]

    let paymentProviders = [
        PaymentAgent(
            slug: "amex",
            prettyName: "Amex (API)",
            settledTransactionProvider: AmexSettlementProvider(),
            authTransactionProvider: AmexAuthProvider(),
            refundTransactionProvider: AmexRefundProvider()
        ),
        PaymentAgent(
            slug: "mastercard",
            prettyName: "Mastercard (TGX2)",
            settledTransactionProvider: MastercardTGX2SettlementProvider(),
            authTransactionProvider: MastercardAuthProvider(),
            refundTransactionProvider: MastercardTGX2RefundProvider()
        ),
        PaymentAgent(
            slug: "visa",
            prettyName: "Visa",
            settledTransactionProvider: VOPTransactionProvider(transactionType: .settlement),
            authTransactionProvider: VOPTransactionProvider(transactionType: .auth),
            refundTransactionProvider: VOPRefundProvider()
        )
    ]
}
