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
        buildMerchantMenu()
        buildPaymentMenu()
    }
    
    // MARK: - Menu
    
    private func buildMerchantMenu() {
        merchantMenu.autoenablesItems = false
        merchantMenu.removeAllItems()
        
        let merchants = AgentController.shared.merchants
        let sortedMerchants = merchants.sorted { $0.slug < $1.slug }

        addMenuTitle("Select a merchant", inMenu: merchantMenu)
        addSeperator(inMenu: merchantMenu)
        _ = sortedMerchants.map { addMenuItem($0, inMenu: merchantMenu)}
    }
    
    private func buildPaymentMenu() {
        paymentMenu.autoenablesItems = false
        paymentMenu.removeAllItems()
        addMenuTitle("Select a payment scheme", inMenu: paymentMenu)
        addSeperator(inMenu: paymentMenu)
        _ = AgentController.shared.paymentProviders.map { addMenuItem($0, inMenu: paymentMenu) }
    }
    
    private func addMenuItem(_ object: PrettyNamedObject, inMenu menu: NSMenu) {
        let item = NSMenuItem(title: object.prettyName, action: nil, keyEquivalent: "")
        item.representedObject = object
        menu.addItem(item)
    }
    
    private func addMenuTitle(_ title: String, inMenu menu: NSMenu) {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        menu.addItem(item)
    }
    
    private func addSeperator(inMenu menu: NSMenu) {
        menu.addItem(NSMenuItem.separator())
    }
    
    // MARK: - IBActions
    
    @IBAction func generateButtonWasPressed(_ sender: Any) {
        guard let appVC = window?.contentViewController as? MainViewController else { return }
        guard let merchant = merchantPopUp.selectedItem?.representedObject as? MerchantAgent else { return }
        guard let paymentProvider = paymentPopUp.selectedItem?.representedObject as? PaymentAgent else { return }
        appVC.generateFilesFor(merchant: merchant, paymentProvider: paymentProvider)
    }
}
