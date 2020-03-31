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
        if let validationError = getValidationError() {
            validationErrorsLabel.stringValue = validationError
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
    func validateAmount() -> String? {
        if !amountField.stringValue.isNumber {
            return "Amount \"\(amountField.stringValue)\" is not a number."
        }

        return nil
    }

    func validateFirstSix() -> String? {
        if !firstSixField.stringValue.isNumber {
            return "First six \"\(firstSixField.stringValue)\" is not a number."
        }

        if firstSixField.stringValue.count != 6 {
            return "First six must be exactly six digits."
        }

        return nil
    }

    func validateLastFour() -> String? {
        if !lastFourField.stringValue.isNumber {
            return "Last four \"\(lastFourField.stringValue)\" is not a number."
        }

        if lastFourField.stringValue.count != 4 {
            return "Last four must be exactly four digits."
        }

        return nil
    }

    // TODO: return multiple and show all at once
    func getValidationError() -> String? {
        if !allFieldsHaveContent {
            return "All fields must be present."
        }

        if let amountError = validateAmount() {
            return amountError
        }

        if let firstSixError = validateFirstSix() {
            return firstSixError
        }

        if let lastFourError = validateLastFour() {
            return lastFourError
        }

        return nil
    }
}

protocol AddTransactionsViewControllerDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}

// TODO: move this?
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
