//
//  Date.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 05/10/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

extension Date {
    var nearestMinute: Date {
        // rounds the date to the nearest minute
        // we force unwrap twice in here as there should be no way for the conversions to fail in this instance
        let cal = Calendar.current
        let ownComponents = cal.dateComponents([.second], from: self)
        let shiftedDate = ownComponents.second! >= 30 ? cal.date(byAdding: .second, value: 30, to: self)! : self
        let components = cal.dateComponents([.year, .month, .day, .hour, .minute], from: shiftedDate)
        return cal.date(from: components)!
    }
}
