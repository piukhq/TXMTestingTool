//
//  MainViewController.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 31/03/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    // MARK: - Helpers

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var footerSegment: NSSegmentedControl!
    @IBOutlet weak var merchantPicker: NSPopUpButton!
    @IBOutlet weak var paymentProviderPicker: NSPopUpButton!

    // MARK: - Properties
    //var transactions = [Transaction]()
    var transactions = [
        Transaction(mid: "abc123", date: Date(), amount: 1699, cardToken: "token-123", firstSix: "123456", lastFour: "7890"),
        Transaction(mid: "def456", date: Date(), amount: 1799, cardToken: "token-234", firstSix: "123456", lastFour: "7890"),
        Transaction(mid: "ghi789", date: Date(), amount: 1899, cardToken: "token-345", firstSix: "123456", lastFour: "7890"),
        Transaction(mid: "jkl012", date: Date(), amount: 1999, cardToken: "token-456", firstSix: "123456", lastFour: "7890"),
    ]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        merchantPicker.addItems(withTitles: [
            "Harvey Nichols",
            "Iceland",
            "Burger King"
        ])

        paymentProviderPicker.addItems(withTitles: [
            "Amex",
            "MasterCard"
        ])
    }

    // MARK: - IBActions
    @IBAction func footerSegmentWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "createTransaction", sender: sender)
    }

    // MARK: - General
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "createTransaction":
            let vc = segue.destinationController as? AddTransactionViewController
            vc?.delegate = self
        case "generateOutput":
            let vc = segue.destinationController as? GenerateOutputViewController
            vc?.transactions = transactions
        default:
            break
        }
    }
}

extension MainViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return transactions.count
    }
}

extension MainViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellID = NSUserInterfaceItemIdentifier(rawValue: "row")
        guard let cell = tableView.makeView(withIdentifier: cellID, owner: self) as? NSTableCellView else {
            return nil
        }

        let transaction = transactions[row]

        switch tableColumn?.identifier.rawValue {
        case "mid":
            cell.textField?.stringValue = transaction.mid
        case "date":
            cell.textField?.stringValue = Transaction.dateFormatter.string(from: transaction.date)
        case "amount":
            cell.textField?.stringValue = "\(transaction.amount)"
        case "cardToken":
            cell.textField?.stringValue = transaction.cardToken
        case "firstSix":
            cell.textField?.stringValue = transaction.firstSix
        case "lastFour":
            cell.textField?.stringValue = transaction.lastFour
        default:
            break
        }

        return cell
    }
}

extension MainViewController: AddTransactionsViewControllerDelegate {
    func didAddTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        tableView.reloadData()
    }
}
