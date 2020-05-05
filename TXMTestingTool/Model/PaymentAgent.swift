//
//  PaymentAgent.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 29/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

struct PaymentAgent: PrettyNamedObject {
    let slug: String
    let prettyName: String
    let settled: Agent
    let auth: Agent?

    init(
        slug: String,
        prettyName: String,
        settledTransactionProvider: Provider,
        authTransactionProvider: Provider? = nil
    ) {
        self.slug = slug
        self.prettyName = prettyName
        settled = Agent(
            slug: slug,
            prettyName: prettyName,
            transactionProvider: settledTransactionProvider
        )
        if let authTransactionProvider = authTransactionProvider {
            auth = Agent(
                slug: slug,
                prettyName: prettyName,
                transactionProvider: authTransactionProvider
            )
        } else {
            auth = nil
        }
    }
}
