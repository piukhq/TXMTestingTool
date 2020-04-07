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
    
    private func buildMenu(_ menu: NSMenu, from agents: [Agent]) {
        menu.removeAllItems()
        
        for agent in agents {
            let item = NSMenuItem(title: agent.prettyName, action: nil, keyEquivalent: "")
            item.representedObject = agent
            menu.items.append(item)
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
