//
//  Transaction.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 31/03/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct Transaction {
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter
    }

    let mid: String
    let date: Date
    let amount: Int
    let cardToken: String
    let firstSix: String
    let lastFour: String

    // Settlement key is generated on export rather than being entered by the user.
    let settlementKey: String
}
