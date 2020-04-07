//
//  String.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 07/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

extension String  {
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    static func randomDigits(length: Int) -> String {
        let digits = "0123456789"
        return String((0..<length).map { _ in digits.randomElement() ?? "0" })
    }
}
