//
//  AddTransactionViewController.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 31/03/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Cocoa

class AddTransactionViewController: NSViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var midField: ValidatableTextField!
    @IBOutlet weak var dateField: NSDatePicker!
    @IBOutlet weak var amountField: ValidatableTextField!
    @IBOutlet weak var cardTokenField: ValidatableTextField!
    @IBOutlet weak var firstSixField: ValidatableTextField!
    @IBOutlet weak var lastFourField: ValidatableTextField!
    @IBOutlet weak var validationErrorsLabel: NSTextField!
    @IBOutlet weak var addButton: NSButton!

    // MARK: - Properties
    
    weak var delegate: AddTransactionsViewControllerDelegate?
    
    lazy var validationFields = [
        midField,
        amountField,
        cardTokenField,
        firstSixField,
        lastFourField
    ]

    // MARK: - Initialisation
    
    init?(coder: NSCoder, delegate: AddTransactionsViewControllerDelegate) {
        self.delegate = delegate
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareValidators()
        addButton.becomeFirstResponder()
    }
    
    func prepareValidators() {
        midField.setup("MID", validation: [.hasContent])
        amountField.setup("Amount", validation: [.hasContent, .isNumeric])
        cardTokenField.setup("Card Token", validation: [.hasContent])
        firstSixField.setup("First six", validation: [.hasContent, .isNumeric, .lengthEquals(6)])
        lastFourField.setup("Last four", validation: [.hasContent, .isNumeric, .lengthEquals(4)])
    }

    // MARK: - IBActions
    
    @IBAction func addButtonWasPressed(_ sender: Any) {
        let validationErrors = validationFields.map { $0?.isValid }.filter { $0?.error != nil }
        
        if validationErrors.count > 0 {
            validationErrorsLabel.stringValue = validationErrors.map { $0?.error ?? "" }.joined(separator: "\n")
            
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
}

protocol AddTransactionsViewControllerDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}
