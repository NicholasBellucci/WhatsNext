//
//  RootFlow.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/6/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa
import EventKit

class RootFlow {
    private var statusMenuController: StatusMenuController?
    private var currentEvent: EKEvent?

    required init () {}
}

extension RootFlow {
    func loadStatusMenu(statusItem: NSStatusItem) {
        NotificationCenter.default.addObserver(self, selector: #selector(eventNotification(_:)),
                                               name: Notifications.alert.name, object: nil)

        let presenter = StatusMenuPresenter()
        statusMenuController = StatusMenuController(presenter: presenter, statusItem: statusItem)
        statusMenuController?.setup()
    }
}

private extension RootFlow {
    @objc
    func eventNotification(_ sender: Notification) {
        guard let event = sender.object as? EKEvent else { return }
        guard event != currentEvent else { return }
        currentEvent = event
        let controller = NotificationWindowController(event: event)
        guard let window = controller.window else { return }
        NSApp.runModal(for: window)
    }
}
