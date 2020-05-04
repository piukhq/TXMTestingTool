//
//  PaymentProvider.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 29/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

struct PaymentProvider {
    let settledAgent: Agent
    let authAgent: Agent?

    init(
        slug: String,
        prettyName: String,
        defaultSettledFileName: String,
        settledTransactionProvider: Provider
    ) {
        settledAgent = Agent(
            slug: slug,
            prettyName: prettyName,
            defaultFileName: defaultSettledFileName,
            transactionProvider: settledTransactionProvider
        )
        authAgent = nil
    }

    init(
        slug: String,
        prettyName: String,
        defaultSettledFileName: String,
        settledTransactionProvider: Provider,
        defaultAuthFilename: String,
        authTransactionProvider: Provider
    ) {
        settledAgent = Agent(
            slug: slug,
            prettyName: prettyName,
            defaultFileName: defaultSettledFileName,
            transactionProvider: settledTransactionProvider
        )
        authAgent = Agent(
            slug: slug, prettyName: prettyName,
            defaultFileName: defaultAuthFilename,
            transactionProvider: authTransactionProvider
        )
    }
}
