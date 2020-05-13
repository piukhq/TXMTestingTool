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
    
    private enum Output {
        case merchant
        case settle
        case auth
    }

    // MARK: - IBOutlets
    
    @IBOutlet weak var merchantOutput: NSTextView!
    @IBOutlet weak var paymentProviderOutput: NSTextView!
    @IBOutlet weak var paymentAuthProviderOutput: NSTextView!
    @IBOutlet weak var merchantNameLabel: NSTextField!
    @IBOutlet weak var paymentProviderNameLabel: NSTextField!
    @IBOutlet weak var paymentAuthProviderNameLabel: NSTextField!
    @IBOutlet weak var saveMerchantFileButton: NSButton!
    @IBOutlet weak var saveSettleFileButton: NSButton!
    @IBOutlet weak var saveAuthFileButton: NSButton!

    // MARK: - Properties
    
    /*
     Typically this is bad form, but, taking a leaf out of the IBOutlet book above, by declaring these with a ! we are
     stating that these will always have a value when we read from them. Creating view controllers from storyboards
     limit us with how we can initialise values we need to pass in. If we ensure we call prepareViewControllerWith:
     we effectively get the same result but can workaround the limiations.
     */
    var merchantAgent: MerchantAgent!
    var paymentAgent: PaymentAgent!
    var transactions: [Transaction]!

    // MARK: - Initialisation
    
    func prepareViewControllerWith(merchant: MerchantAgent, paymentProvider: PaymentAgent, transactions: [Transaction]) {
        self.merchantAgent = merchant
        self.paymentAgent = paymentProvider
        self.transactions = transactions
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(for: merchantAgent.transactionProvider, outputType: .merchant)
        updateUI(for: paymentAgent.settled, outputType: .settle)
        updateUI(for: paymentAgent.auth, outputType: .auth)
    }

    // MARK: - IBActions
    
    @IBAction func saveMerchantFileWasPressed(_ sender: Any) {
        saveFile(merchantOutput.string, provider: merchantAgent.transactionProvider)
    }

    @IBAction func savePaymentProviderFileWasPressed(_ sender: Any) {
        saveFile(paymentProviderOutput.string, provider: paymentAgent.settled)
    }

    @IBAction func savePaymentAuthProviderFileWasPressed(_ sender: Any) {
        if let authAgent = paymentAgent.auth {
            saveFile(paymentAuthProviderOutput.string, provider: authAgent)
        }
    }

    // MARK: - General
    
    func saveFile(_ content: String, provider: Provider?) {
        guard let provider = provider else { return }
        
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
    
    func provideContent(provider: Provider?, into textView: NSTextView) {
        guard let provider = provider else { return } // No provider, nothing to do
        
        do {
            let content = try provider.provide(transactions, merchant: merchantAgent, paymentProvider: paymentAgent)
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
    
    private func updateUI(for provider: Provider?, outputType: Output) {
        guard let provider = provider else {
            disableUI(for: outputType)
            return
        }
        
        switch outputType {
        case .merchant:
            merchantNameLabel.stringValue = "\(merchantAgent.prettyName)"
            provideContent(provider: provider, into: merchantOutput)
        case .settle:
            paymentProviderNameLabel.stringValue = "\(paymentAgent.prettyName) Settled Transactions"
            provideContent(provider: provider, into: paymentProviderOutput)
        case .auth:
            paymentAuthProviderNameLabel.stringValue = "\(paymentAgent.prettyName) Auth Transactions"
            provideContent(provider: provider, into: paymentAuthProviderOutput)
        }
    }
    
    private func disableUI(for output: Output) {
        switch output {
        case .merchant:
            disableElements(label: merchantNameLabel, outputBox: merchantOutput, button: saveMerchantFileButton)
        case .settle:
            disableElements(label: paymentProviderNameLabel, outputBox: paymentProviderOutput, button: saveSettleFileButton)
        case .auth:
            disableElements(label: paymentAuthProviderNameLabel, outputBox: paymentAuthProviderOutput, button: saveAuthFileButton)
        }
    }
}
