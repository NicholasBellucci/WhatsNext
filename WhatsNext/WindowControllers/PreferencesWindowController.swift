//
//  PreferencesWindowController.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/4/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

    private lazy var preferenceWindow: NSWindow = {
        let rect = NSRect(x: 0, y: 0, width: 500, height: 500)
        let window = NSWindow(contentRect: rect, styleMask: [.titled, .closable, .resizable], backing: .buffered, defer: false)
        return window
    }()

    required init() {
        super.init(window: nil)
        window = preferenceWindow
        window?.center()
        NSApp.activate(ignoringOtherApps: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
