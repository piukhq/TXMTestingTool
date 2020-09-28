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
    
    private struct Constants {
        static let defaultsKey = "transactions"
    }
    
    enum SegmentButtons: Int {
        case add
        case remove
        case randomize
    }

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var footerSegment: NSSegmentedControl!

    // MARK: - Properties
    
    var transactions: [Transaction] = {
        guard
            let transactionData = UserDefaults.standard.object(forKey: Constants.defaultsKey) as? Data,
            let transactions = try? PropertyListDecoder().decode([Transaction].self, from: transactionData)
        else {
            return [Transaction]()
        }
        
        return transactions
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.intercellSpacing = NSSize(width: 10, height: 2)
    }

    // MARK: - IBActions

    @IBAction func footerSegmentWasPressed(_ sender: Any) {
        guard let selectedSegment = SegmentButtons(rawValue: footerSegment.selectedSegment) else {
            fatalError("footer segment has more buttons than expected - missing value from SegmentButtons")
        }

        switch selectedSegment {
        case .add:
            addNewTransaction()
        case .remove:
            removeTransaction()
        case .randomize:
            randomizeTransactions()
        }
    }

    // MARK: - General
    
    func generateFilesFor(merchant: MerchantAgent, paymentProvider: PaymentAgent) {
        guard let destination = NSStoryboard.fromMain(loadController: GenerateOutputViewController.self) else {
            fatalError("Unable to load our view controller from the storyboard")
        }
        
        destination.prepareViewControllerWith(
            merchant: merchant,
            paymentProvider: paymentProvider,
            transactions: transactions
        )
        
        presentAsSheet(destination)
    }

    private func addNewTransaction() {
        guard let destination = NSStoryboard.fromMain(loadController: AddTransactionViewController.self) else {
            fatalError("Unable to load our view controller from the storyboard")
        }
        
        destination.delegate = self
        presentAsSheet(destination)
    }

    private func removeTransaction() {
        guard case let row = tableView.selectedRow, row >= 0 else { return }
        transactions.remove(at: row)
        persistTransactions()
        tableView.reloadData()
    }

    private func randomizeTransactions() {
        transactions.removeAll()

        let generatorQueue = DispatchQueue(label: "transactions", attributes: .concurrent)
        generatorQueue.async { [weak self] in
            for _ in 1...1000000 {
                self?.transactions.append(
                    Transaction(mid: "a", storeID: "b", date: Date(), amount: 0, cardToken: "a", firstSix: "0", lastFour: "0")
                )
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func persistTransactions() {
        if let transactionData = try? PropertyListEncoder().encode(transactions) {
            UserDefaults.standard.set(transactionData, forKey: Constants.defaultsKey)
        }
    }
}

// MARK: - NSTableViewDataSource & NSTableViewDelegate

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
        case "storeID":
            cell.textField?.stringValue = transaction.storeID
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

// MARK: - AddTransactionsViewControllerDelegate

extension MainViewController: AddTransactionsViewControllerDelegate {
    func didAddTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        persistTransactions()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
