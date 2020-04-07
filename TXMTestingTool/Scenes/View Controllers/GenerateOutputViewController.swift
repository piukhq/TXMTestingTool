//
//  GenerateOutputViewController.swift
//  TXMTestingTool
//
//  Created by Chris Latham on 01/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Cocoa

class GenerateOutputViewController: NSViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var merchantOutput: NSTextView!
    @IBOutlet weak var paymentProviderOutput: NSTextView!
    @IBOutlet weak var merchantNameLabel: NSTextField!
    @IBOutlet weak var paymentProviderNameLabel: NSTextField!

    // MARK: - Properties
    
    /*
     Typically this is bad form, but, taking a leaf out of the IBOutlet book above, by declaring these with a ! we are
     stating that these will always have a value when we read from them. Creating view controllers from storyboards
     limit us with how we can initialise values we need to pass in. If we ensure we call prepareViewControllerWith:
     we effectively get the same result but can workaround the limiations.
     */
    var merchant: Agent!
    var paymentProvider: Agent!
    var transactions: [Transaction]!

    // MARK: - Initialisation
    
    func prepareViewControllerWith(merchant: Agent, paymentScheme: Agent, transactions: [Transaction]) {
        self.merchant = merchant
        self.paymentProvider = paymentScheme
        self.transactions = transactions
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
        saveFile(merchantOutput.string, provider: merchant)
    }

    @IBAction func savePaymentProviderFileWasPressed(_ sender: Any) {
        saveFile(paymentProviderOutput.string, provider: paymentProvider)
    }

    // MARK: - General
    
    func saveFile(_ content: String, provider: Agent) {
        guard let window = view.window else {
            fatalError("failed to get view window when saving transactions file")
        }
        let panel = NSSavePanel()
        panel.nameFieldStringValue = provider.defaultFileName
        panel.beginSheetModal(for: window) { result in
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

    func provideContent(provider: Agent, into textView: NSTextView) {
        do {
            let content = try provider.transactionProvider.provide(transactions, merchant: merchant, paymentProvider: paymentProvider)
            textView.string = content
        } catch {
            textView.string = "Failed to generate output: \(error)"
        }
    }
}
