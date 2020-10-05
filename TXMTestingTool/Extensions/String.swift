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

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    func safeSuffix(from: Int) -> String {
        guard let fromIndex = self.index(self.startIndex, offsetBy: from, limitedBy: self.endIndex) else {
            return self
        }
        return String(self.suffix(from: fromIndex))
    }
}
