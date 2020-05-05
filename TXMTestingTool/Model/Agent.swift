//
//  Agent.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 02/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct Agent: PrettyNamedObject {
    var slug: String
    var prettyName: String
    var transactionProvider: Provider?
}
