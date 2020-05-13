//
//  PaymentAgent.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 29/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

struct PaymentAgent: Agent {
    let slug: String
    let prettyName: String
    
    let settled: Provider
    let auth: Provider?

    init(slug: String, prettyName: String, settledTransactionProvider: Provider, authTransactionProvider: Provider? = nil) {
        self.slug = slug
        self.prettyName = prettyName
        self.settled = settledTransactionProvider
        self.auth = authTransactionProvider
    }
}
