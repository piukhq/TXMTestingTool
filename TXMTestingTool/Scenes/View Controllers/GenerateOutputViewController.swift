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
    @IBOutlet weak var saveMerchantFileButton: NSButton!
    @IBOutlet weak var saveAuthFileButton: NSButton!

    // MARK: - Properties
    
    /*
     Typically this is bad form, but, taking a leaf out of the IBOutlet book above, by declaring these with a ! we are
     stating that these will always have a value when we read from them. Creating view controllers from storyboards
     limit us with how we can initialise values we need to pass in. If we ensure we call prepareViewControllerWith:
     we effectively get the same result but can workaround the limiations.
     */
    var merchant: Agent!
    var paymentProvider: PaymentAgent!
    var transactions: [Transaction]!

    // MARK: - Initialisation
    
    func prepareViewControllerWith(merchant: Agent, paymentProvider: PaymentAgent, transactions: [Transaction]) {
        self.merchant = merchant
        self.paymentProvider = paymentProvider
        self.transactions = transactions
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        provideContent(provider: merchant, into: merchantOutput)
        provideContent(provider: paymentProvider.settled, into: paymentProviderOutput)

        if merchant.transactionProvider != nil {
            merchantNameLabel.stringValue = merchant.prettyName
        } else {
            disableElements(label: merchantNameLabel, outputBox: merchantOutput, button: saveMerchantFileButton)
        }

        paymentProviderNameLabel.stringValue = "\(paymentProvider.prettyName) Settled Transactions"

        if let authAgent = paymentProvider.auth {
            provideContent(provider: authAgent, into: paymentAuthProviderOutput)
            paymentAuthProviderNameLabel.stringValue = "\(authAgent.prettyName) Auth Transactions"
        } else {
            disableElements(label: paymentAuthProviderNameLabel, outputBox: paymentAuthProviderOutput, button: saveAuthFileButton)
        }
    }

    // MARK: - IBActions
    
    @IBAction func saveMerchantFileWasPressed(_ sender: Any) {
        saveFile(merchantOutput.string, agent: merchant)
    }

    @IBAction func savePaymentProviderFileWasPressed(_ sender: Any) {
        saveFile(paymentProviderOutput.string, agent: paymentProvider.settled)
    }

    @IBAction func savePaymentAuthProviderFileWasPressed(_ sender: Any) {
        if let authAgent = paymentProvider.auth {
            saveFile(paymentAuthProviderOutput.string, agent: authAgent)
        }
    }

    // MARK: - General
    
    func saveFile(_ content: String, agent: Agent) {
        guard let window = view.window else {
            fatalError("failed to get view window when saving transactions file")
        }
        let panel = NSSavePanel()
        panel.nameFieldStringValue = agent.transactionProvider?.defaultFileName ?? ""
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
        guard let provider = provider.transactionProvider else {
            return  // no provider, nothing to do
        }
        do {
            let content = try provider.provide(transactions, merchant: merchant, paymentProvider: paymentProvider)
            textView.string = content
        } catch {
            textView.string = "Failed to generate output: \(error)"
        }
    }

    func disableElements(label: NSTextField, outputBox: NSTextView, button: NSButton) {
        label.textColor = .tertiaryLabelColor
        outputBox.isEditable = false
        outputBox.alphaValue = 0.5
        outputBox.string = ""
        button.isEnabled = false
    }
}
