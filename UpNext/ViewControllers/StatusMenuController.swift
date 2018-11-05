//
//  StatusMenuController.swift
//  UpNext
//
//  Created by Nicholas Bellucci on 11/3/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa
import EventKit

class StatusMenuController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!

    private lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        return statusItem
    }()

    private lazy var windowController: PreferencesWindowController = {
        let windowController = PreferencesWindowController()
        return windowController
    }()

    override func awakeFromNib() {
        statusItem.button?.title = "Calendar"
        statusItem.menu = statusMenu
    }

    @IBAction func preferencesClicked(_ sender: Any) {
        windowController.showWindow(self)
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
