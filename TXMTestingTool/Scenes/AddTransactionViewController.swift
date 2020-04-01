//
//  AddTransactionViewController.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 31/03/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Cocoa

class AddTransactionViewController: NSViewController {
    // MARK: - Helpers

    // MARK: - IBOutlets
    @IBOutlet weak var midField: NSTextField!
    @IBOutlet weak var dateField: NSDatePicker!
    @IBOutlet weak var amountField: NSTextField!
    @IBOutlet weak var cardTokenField: NSTextField!
    @IBOutlet weak var firstSixField: NSTextField!
    @IBOutlet weak var lastFourField: NSTextField!

    @IBOutlet weak var validationErrorsLabel: NSTextField!

    @IBOutlet weak var addButton: NSButton!

    // MARK: - Properties
    weak var delegate: AddTransactionsViewControllerDelegate?

    lazy var allFields = [
        midField,
        dateField,
        amountField,
        cardTokenField,
        firstSixField,
        lastFourField
    ]

    var allFieldsHaveContent: Bool {
        for field in allFields {
            if field?.stringValue.count == 0 {
                return false
            }
        }
        return true
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.becomeFirstResponder()
    }

    // MARK: - IBActions
    @IBAction func addButtonWasPressed(_ sender: Any) {
        let validationErrors = getValidationErrors()
        if validationErrors.count > 0 {
            validationErrorsLabel.stringValue = validationErrors
            validationErrorsLabel.isHidden = false
            return
        }

        let transaction = Transaction(
            mid: midField.stringValue,
            date: dateField.dateValue,
            amount: Int(amountField.stringValue)!,
            cardToken: cardTokenField.stringValue,
            firstSix: firstSixField.stringValue,
            lastFour: lastFourField.stringValue
        )

        delegate?.didAddTransaction(transaction)

        dismiss(self)
    }
    
    // MARK: - General
    func validateAllFields() -> String? {
        if !allFieldsHaveContent {
            return "All fields must be present."
        }

        return nil
    }

    func validateAmount() -> String? {
        if !amountField.stringValue.isNumeric {
            return "Amount must be numeric."
        }

        return nil
    }

    func validateFirstSixIsNumeric() -> String? {
        if !firstSixField.stringValue.isNumeric {
            return "First six must be numeric."
        }

        return nil
    }

    func validateFirstSixHasLengthSix() -> String? {
        if firstSixField.stringValue.count != 6 {
            return "First six must be exactly six digits."
        }

        return nil
    }

    func validateLastFourIsNumeric() -> String? {
        if !lastFourField.stringValue.isNumeric {
            return "Last four must be numeric."
        }

        return nil
    }

    func validateLastFourHasLengthFour() -> String? {
        if lastFourField.stringValue.count != 4 {
            return "Last four must be exactly four digits."
        }

        return nil
    }

    let allValidators: [(AddTransactionViewController) -> () -> String?] = [
        validateAllFields,
        validateAmount,
        validateFirstSixIsNumeric,
        validateFirstSixHasLengthSix,
        validateLastFourIsNumeric,
        validateLastFourHasLengthFour
    ]

    func getValidationErrors() -> String {
        var errors = [String]()

        for validator in allValidators {
            if let error = validator(self)() {
                errors.append("• \(error)")
            }
        }

        return errors.joined(separator: "\n")
    }
}

protocol AddTransactionsViewControllerDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}

// TODO: move this?
extension String  {
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
