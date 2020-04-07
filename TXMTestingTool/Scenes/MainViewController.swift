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
    enum SegmentButtons: Int {
        case add
        case remove
    }

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var footerSegment: NSSegmentedControl!
    @IBOutlet weak var merchantPicker: NSPopUpButton!
    @IBOutlet weak var paymentProviderPicker: NSPopUpButton!

    // MARK: - Properties
    //var transactions = [Transaction]()
    var transactions = [
        Transaction(mid: "abc123", date: Date(), amount: 1699, cardToken: "token-123", firstSix: "123456", lastFour: "7890"),
        Transaction(mid: "def456", date: Date(), amount: 1799, cardToken: "token-234", firstSix: "234567", lastFour: "8901"),
        Transaction(mid: "ghi789", date: Date(), amount: 1899, cardToken: "token-345", firstSix: "345678", lastFour: "9012"),
        Transaction(mid: "jkl012", date: Date(), amount: 1999, cardToken: "token-456", firstSix: "456789", lastFour: "0123"),
    ]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        merchantPicker.addItems(withTitles: ProviderController.shared.merchants.map { $0.prettyName })
        paymentProviderPicker.addItems(withTitles: ProviderController.shared.paymentProviders.map { $0.prettyName })
    }

    // MARK: - IBActions
    @IBAction func generateWasPressed(_ sender: Any) {
        guard let generateOutputViewController = NSStoryboard.main?.instantiateController(
            identifier: Constants.StoryboardIDs.generateOutputViewController,
            creator: { [weak self] (coder) -> GenerateOutputViewController? in
                guard let self = self else {
                    return nil
                }
                return GenerateOutputViewController(
                    coder: coder,
                    merchant: self.getSelectedMerchant(),
                    paymentProvider: self.getSelectedPaymentProvider(),
                    transactions: self.transactions
                )
            }
        ) else {
            return
        }

        presentAsModalWindow(generateOutputViewController)
    }

    @IBAction func footerSegmentWasPressed(_ sender: Any) {
        guard let selectedSegment = SegmentButtons(rawValue: footerSegment.selectedSegment) else {
            fatalError("footer segment has more buttons than expected - missing value from SegmentButtons")
        }

        switch selectedSegment {
        case .add:
            addNewTransaction()
        case .remove:
            removeTransaction()
        }
    }

    // MARK: - General
    func getSelectedMerchant() -> Provider {
        let selection = merchantPicker.indexOfSelectedItem
        return ProviderController.shared.merchants[selection]
    }

    func getSelectedPaymentProvider() -> Provider {
        let selection = paymentProviderPicker.indexOfSelectedItem
        return ProviderController.shared.paymentProviders[selection]
    }

    func addNewTransaction() {
        guard let vc = NSStoryboard.main?.instantiateController(
            identifier: Constants.StoryboardIDs.addTransactionViewController,
            creator: { (coder) -> AddTransactionViewController? in
                return AddTransactionViewController(
                    coder: coder,
                    delegate: self
                )
            }
        ) else {
                return
        }

        presentAsSheet(vc)
    }

    func removeTransaction() {
        let selectedTransaction = tableView.selectedRow
        if selectedTransaction < 0 {
            return
        }
        transactions.remove(at: selectedTransaction)
        tableView.reloadData()
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
