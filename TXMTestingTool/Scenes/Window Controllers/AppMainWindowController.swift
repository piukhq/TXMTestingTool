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
        buildMenu(merchantMenu, from: AgentController.shared.merchants)
        buildMenu(paymentMenu, from: AgentController.shared.paymentProviders)
    }
    
    // MARK: - Menu
    
    private func buildMenu(_ menu: NSMenu, from objects: [PrettyNamedObject]) {
        menu.removeAllItems()
        
        for object in objects {
            let item = NSMenuItem(title: object.prettyName, action: nil, keyEquivalent: "")
            item.representedObject = object
            menu.items.append(item)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func generateButtonWasPressed(_ sender: Any) {
        guard let appVC = window?.contentViewController as? MainViewController else { return }
        guard let merchant = merchantPopUp.selectedItem?.representedObject as? MerchantAgent else { return }
        guard let paymentProvider = paymentPopUp.selectedItem?.representedObject as? PaymentAgent else { return }
        appVC.generateFilesFor(merchant: merchant, paymentProvider: paymentProvider)
    }
}
