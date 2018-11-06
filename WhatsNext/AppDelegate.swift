//
//  AppDelegate.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/3/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var rootFlow: RootFlow?

    private lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = statusMenu
        return statusItem
    }()

    private lazy var statusMenu: NSMenu = {
        let menu = NSMenu(title: "Calendar")
        menu.addItem(withTitle: "Open Calendar", action: #selector(calendarAction(_:)), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
//        menu.addItem(withTitle: "Preferences", action: #selector(preferencesAction(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(quitAction(_:)), keyEquivalent: "")
        return menu
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let rootFlow = RootFlow()
        rootFlow.loadStatusMenu(statusItem: statusItem)
        self.rootFlow = rootFlow
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc
    func calendarAction(_ sender: NSMenuItem) {
        NSWorkspace.shared.launchApplication("Calendar")
    }

    @objc
    func preferencesAction(_ sender: NSMenuItem) {
//        windowController.showWindow(self)
    }

    @objc
    func quitAction(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}

