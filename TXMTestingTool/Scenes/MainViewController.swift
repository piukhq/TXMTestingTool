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

    // MARK: - Properties
    var transactions: [Transaction] = [
        Transaction(mid: "abc123", date: Date(), amount: 1699, cardToken: "token123", firstSix: "000000", lastFour: "0000"),
        Transaction(mid: "def123", date: Date(), amount: 1799, cardToken: "token456", firstSix: "000000", lastFour: "0000"),
        Transaction(mid: "ghi123", date: Date(), amount: 1899, cardToken: "token789", firstSix: "000000", lastFour: "0000")
    ]

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction func footerSegmentWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "createTransaction", sender: sender)
    }

    // MARK: - General
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let vc = segue.destinationController as? AddTransactionViewController
        vc?.delegate = self
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

        // TODO: move this elsewhere :)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD hh:mm:ss"

        let transaction = transactions[row]

        switch tableColumn?.identifier.rawValue {
        case "mid":
            cell.textField?.stringValue = transaction.mid
        case "date":
            cell.textField?.stringValue = dateFormatter.string(from: transaction.date)
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
