//
//  NotificationWindowController.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/6/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

class NotificationWindowController: NSWindowController {
    private lazy var notificationWindow: NSWindow = {
        let window = NSWindow(contentViewController: notificationViewController)
        window.setFrame(NSRect(x: 0, y: 0, width: 345, height: 85), display: true)
        window.backgroundColor = .clear
        window.styleMask = [NSWindow.StyleMask.fullSizeContentView]
        window.isMovableByWindowBackground = true
        window.isOpaque = false
        return window
    }()

    private lazy var notificationViewController: NSViewController = {
        let viewController = NotificationViewController()
        return viewController
    }()

    required init() {
        super.init(window: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NotificationWindowController {
    func setup() {
        window = notificationWindow
    }
}
