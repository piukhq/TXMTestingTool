//
//  AmexRefundProvider.swift
//  TXMTestingTool
//
//  Created by Michal Jozwiak on 14/12/2021.
//  Copyright © 2021 Bink. All rights reserved.
//

import Foundation


struct AmexRefundProvider: Provider {
    func provide(_ transactions: [Transaction], merchant: MerchantAgent, paymentProvider: PaymentAgent) throws -> String {
        let amexTransactions = transactions.map {
            AmexTransaction(
                approvalCode: $0.authCode,
                merchantNumber: $0.mid,
                offerId: "0",
                transactionAmount: String(format: "-%.02f", Double($0.amount) / 100.0),
                transactionId: $0.id,
                transactionDate: dateFormatter.string(from: $0.date),
                
                currencyCode: "840",
                partnerId: "AADP0050",
                recordId: "\($0.id)AADP00400",
                cardToken: $0.cardToken,
                dpan: "\($0.firstSix)XXXXX\($0.lastFour)"
            )
        }
        
        let data = try AmexSettlementProvider().jsonEncoder.encode(amexTransactions)
        return String(data: data, encoding: .utf8)!
    }
    
    // MARK: - Properties
    
    var defaultFileName = "amex-refund.json"
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: +25200)  // UTC +7
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
