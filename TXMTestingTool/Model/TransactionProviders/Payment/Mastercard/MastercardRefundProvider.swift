//
//  MastercardRefundProvider.swift
//  TXMTestingTool
//
//  Created by Michal Jozwiak on 15/09/2022.
//  Copyright © 2022 Bink. All rights reserved.
//

import Foundation

class MastercardTGX2RefundProvider: MastercardTGX2SettlementProvider {

    override var timeFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: +25200)  // UTC +7
            formatter.dateFormat = "HHmm"
            return formatter
        }
        set {}
    }
    
    override var headerTimeFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: +25200)  // UTC +7
            formatter.dateFormat = "HHmm"
            return formatter
        }
        set {}
    }

    override var defaultFileName: String {
            get {
                return "mastercard-tgx2-refund.txt"
            }
            set {}
        }
}
