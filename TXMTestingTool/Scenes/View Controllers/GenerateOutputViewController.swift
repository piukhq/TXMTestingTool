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
    @IBOutlet weak var paymentAuthProviderOutput: NSTextView!
    @IBOutlet weak var merchantNameLabel: NSTextField!
    @IBOutlet weak var paymentProviderNameLabel: NSTextField!
    @IBOutlet weak var paymentAuthProviderNameLabel: NSTextField!

    // MARK: - Properties
    
    /*
     Typically this is bad form, but, taking a leaf out of the IBOutlet book above, by declaring these with a ! we are
     stating that these will always have a value when we read from them. Creating view controllers from storyboards
     limit us with how we can initialise values we need to pass in. If we ensure we call prepareViewControllerWith:
     we effectively get the same result but can workaround the limiations.
     */
    var merchant: Agent!
    var paymentProvider: PaymentProvider!
    var transactions: [Transaction]!

    // MARK: - Initialisation
    
    func prepareViewControllerWith(merchant: Agent, paymentProvider: PaymentProvider, transactions: [Transaction]) {
        self.merchant = merchant
        self.paymentProvider = paymentProvider
        self.transactions = transactions
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        provideContent(provider: merchant, into: merchantOutput)
        provideContent(provider: paymentProvider.settledAgent, into: paymentProviderOutput)

        merchantNameLabel.stringValue = merchant.prettyName
        paymentProviderNameLabel.stringValue = "\(paymentProvider.settledAgent.prettyName) settled transactions"

        if let authAgent = paymentProvider.authAgent {
            provideContent(provider: authAgent, into: paymentAuthProviderOutput)
            paymentAuthProviderNameLabel.stringValue = "\(authAgent.prettyName) auth transactions"
        }
    }

    // MARK: - IBActions
    
    @IBAction func saveMerchantFileWasPressed(_ sender: Any) {
        saveFile(merchantOutput.string, agent: merchant)
    }

    @IBAction func savePaymentProviderFileWasPressed(_ sender: Any) {
        saveFile(paymentProviderOutput.string, agent: paymentProvider.settledAgent)
    }

    @IBAction func savePaymentAuthProviderFileWasPressed(_ sender: Any) {
        if let authAgent = paymentProvider.authAgent {
            saveFile(paymentAuthProviderOutput.string, agent: authAgent)
        }
    }

    // MARK: - General
    
    func saveFile(_ content: String, agent: Agent) {
        guard let window = view.window else {
            fatalError("failed to get view window when saving transactions file")
        }
        let panel = NSSavePanel()
        panel.nameFieldStringValue = agent.defaultFileName
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
