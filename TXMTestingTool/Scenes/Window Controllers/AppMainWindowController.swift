//
//  AppMainWindowController.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 07/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Cocoa

class AppMainWindowController: NSWindowController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var merchantPopUp: NSPopUpButton!
    @IBOutlet weak var merchantMenu: NSMenu!
    @IBOutlet weak var paymentPopUp: NSPopUpButton!
    @IBOutlet weak var paymentMenu: NSMenu!
    @IBOutlet weak var generateButton: NSButton!
    
    // MARK: - Window Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        prepareMenuContents()
    }
    
    // MARK: - Menu
    
    private func prepareMenuContents() {
        merchantMenu.removeAllItems()
        
        for merchant in ProviderController.shared.merchants {
            let item = NSMenuItem(title: merchant.prettyName, action: nil, keyEquivalent: "")
            item.representedObject = merchant
            merchantMenu.items.append(item)
        }
        
        paymentMenu.removeAllItems()
        
        for payment in ProviderController.shared.paymentProviders {
            let item = NSMenuItem(title: payment.prettyName, action: nil, keyEquivalent: "")
            item.representedObject = payment
            paymentMenu.items.append(item)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func generateButtonWasPressed(_ sender: Any) {
        guard let appVC = window?.contentViewController as? MainViewController else { return }
        guard let merchant = merchantPopUp.selectedItem?.representedObject as? Agent else { return }
        guard let payment = paymentPopUp.selectedItem?.representedObject as? Agent else { return }
        appVC.generateFilesFor(merchant: merchant, paymentScheme: payment)
    }
}
