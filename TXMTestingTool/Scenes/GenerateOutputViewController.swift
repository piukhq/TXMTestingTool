//
//  GenerateOutputViewController.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 01/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Cocoa

class GenerateOutputViewController: NSViewController {
    // MARK: - Helpers

    // MARK: - IBOutlets
    @IBOutlet weak var merchantOutput: NSTextView!
    @IBOutlet weak var paymentProviderOutput: NSTextView!
    @IBOutlet weak var merchantNameLabel: NSTextField!
    @IBOutlet weak var paymentProviderNameLabel: NSTextField!

    // MARK: - Properties
    let merchant: Provider
    let paymentProvider: Provider
    let transactions: [Transaction]

    // MARK: - Initialisation
    init?(coder: NSCoder, merchant: Provider, paymentProvider: Provider, transactions: [Transaction]) {
        self.merchant = merchant
        self.paymentProvider = paymentProvider
        self.transactions = transactions
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        provideContent(provider: merchant, into: merchantOutput)
        provideContent(provider: paymentProvider, into: paymentProviderOutput)

        merchantNameLabel.stringValue = merchant.prettyName
        paymentProviderNameLabel.stringValue = paymentProvider.prettyName
    }

    // MARK: - IBActions
    @IBAction func saveMerchantFileWasPressed(_ sender: Any) {
        saveFile(merchantOutput.string)
    }

    @IBAction func savePaymentProviderFileWasPressed(_ sender: Any) {
        saveFile(paymentProviderOutput.string)
    }

    // MARK: - General
    func saveFile(_ content: String) {
        let panel = NSSavePanel()
        panel.begin() { result in
            if result == .OK {
                guard let url = panel.url else {
                    // TODO: potentially surface some sort of error
                    return
                }

                do {
                    try content.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    let alert = NSAlert(error: error)
                    alert.runModal()
                }
            }
        }
    }

    func provideContent(provider: Provider, into textView: NSTextView) {
        do {
            let content = try provider.transactionProvider.provide(transactions, merchant: merchant, paymentProvider: paymentProvider)
            textView.string = content
        } catch {
            textView.string = "Failed to generate output: \(error)"
        }
    }
}
