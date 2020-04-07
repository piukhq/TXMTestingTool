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
    
    typealias ValidationResult = (isValid: Bool, error: String?)
    
    // MARK: - Properties
    
    var validators: [ValidationType]?
    
    var fieldID: String?
    
    var isValid: ValidationResult {
        guard let validators = validators, let fieldID = fieldID else { return (true, nil) }
        
        for validator in validators {
            switch validator {
            case .hasContent:
                if stringValue.count == 0 {
                    return (false, "You must provide a value for \(fieldID)")
                }
            case .isNumeric:
                if !stringValue.isNumeric {
                    return (false, "\(fieldID) must be a number")
                }
            case let .lengthEquals(length):
                if stringValue.count != length {
                    return (false, "\(fieldID) must have a length of \(length)")
                }
            }
        }
        
        return (true, nil)
    }
    
    // MARK: - General
    
    func setup(_ id: String, validation: [ValidationType]) {
        fieldID = id
        validators = validation
    }
}
