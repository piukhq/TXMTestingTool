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
    @IBOutlet var merchantOutput: NSTextView!
    @IBOutlet var paymentProviderOutput: NSTextView!
    
    // MARK: - Properties
    var transactions = [Transaction]()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let content = try HarveyNicholsTransactionProvider().provide(transactions)
            merchantOutput.string = content
        } catch {
            merchantOutput.string = "Failed to generate output: \(error)"
        }
    }

    // MARK: - IBActions

    // MARK: - General
}
