//
//  ValidatableTextField.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 07/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import AppKit

class ValidatableTextField: NSTextField {
    
    // MARK: - Helpers
    
    enum ValidationType {
        case hasContent
        case isNumeric
        case lengthEquals(Int)
    }
    
    typealias ValidationResult = (passedValidation: Bool, errors: [String])
    
    // MARK: - Properties
    
    var validators: [ValidationType]?
    
    var fieldID: String?
    
    var isValid: ValidationResult {
        var errors = [String]()

        guard let validators = validators, let fieldID = fieldID else { return (true, errors) }

        for validator in validators {
            switch validator {
            case .hasContent:
                if stringValue.count == 0 {
                    errors.append("You must provide a value for \(fieldID).")
                }
            case .isNumeric:
                if !stringValue.isNumeric {
                    errors.append("\(fieldID.capitalizingFirstLetter()) must be a number.")
                }
            case let .lengthEquals(length):
                if stringValue.count != length {
                    errors.append("\(fieldID.capitalizingFirstLetter()) must have a length of \(length).")
                }
            }
        }

        return (errors.count == 0, errors)
    }
    
    // MARK: - General
    
    func setup(_ id: String, validation: [ValidationType]) {
        fieldID = id
        validators = validation
    }
}
