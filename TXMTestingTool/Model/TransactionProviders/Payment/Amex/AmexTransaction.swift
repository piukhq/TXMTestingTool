//
//  AmexTransaction.swift
//  TXMTestingTool
//
//  Created by Michal Jozwiak on 15/09/2022.
//  Copyright © 2022 Bink. All rights reserved.
//

import Foundation

struct AmexTransaction: Codable {
    var approvalCode: String
    var merchantNumber: String
    var offerId: String
    var transactionAmount: String
    var transactionId: String
    var transactionDate: String
    var currencyCode: String
    var partnerId: String
    var recordId: String
    var cardToken: String
    var dpan: String
}
