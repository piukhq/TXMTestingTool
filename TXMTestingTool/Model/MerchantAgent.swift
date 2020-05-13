//
//  Agent.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct MerchantAgent: Agent {
    enum MerchantType {
        case pll
        case plr
    }
    
    var slug: String
    var prettyName: String
    var transactionProvider: Provider?
    var type: MerchantType
    
    init(_ name: String, slug: String, type: MerchantType, provider: Provider? = nil) {
        self.prettyName = name
        self.slug = slug
        self.type = type
        self.transactionProvider = provider
    }
}
