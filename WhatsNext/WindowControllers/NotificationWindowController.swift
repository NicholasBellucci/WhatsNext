//
//  NotificationWindowController.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/6/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa
import EventKit

typealias AbortModalHandler = () -> ()

class NotificationWindowController: NSWindowController {
    lazy var handleAbort: AbortModalHandler = { [weak self] in
        NSApp.abortModal()
        self?.notificationWindow.orderOut(self)
    }

    private var event: EKEvent

    private lazy var notificationWindow: NotificationWindow = {
        let window = NotificationWindow(frame: NSRect(x: 0, y: 0, width: 345, height: 60), placement: .topRight)
        window.contentViewController = notificationViewController
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true
        window.isOpaque = false
        return window
    }()

    private lazy var notificationViewController: NotificationViewController = {
        let presenter = NotificationPresenter(event: event)
        let viewController = NotificationViewController(presenter: presenter)
        viewController.abortHandler = handleAbort
        return viewController
    }()

    required init(event: EKEvent) {
        self.event = event
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
