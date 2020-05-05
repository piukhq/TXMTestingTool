//
//  PaymentAgent.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 29/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

struct PaymentAgent {
    let settled: Agent
    let auth: Agent?

    init(
        slug: String,
        prettyName: String,
        defaultSettledFileName: String,
        settledTransactionProvider: Provider
    ) {
        settled = Agent(
            slug: slug,
            prettyName: prettyName,
            defaultFileName: defaultSettledFileName,
            transactionProvider: settledTransactionProvider
        )
        auth = nil
    }

    init(
        slug: String,
        prettyName: String,
        defaultSettledFileName: String,
        settledTransactionProvider: Provider,
        defaultAuthFilename: String,
        authTransactionProvider: Provider
    ) {
        settled = Agent(
            slug: slug,
            prettyName: prettyName,
            defaultFileName: defaultSettledFileName,
            transactionProvider: settledTransactionProvider
        )
        auth = Agent(
            slug: slug, prettyName: prettyName,
            defaultFileName: defaultAuthFilename,
            transactionProvider: authTransactionProvider
        )
    }
}
