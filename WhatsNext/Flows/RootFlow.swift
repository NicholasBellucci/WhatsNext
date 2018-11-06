//
//  RootFlow.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/6/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa

class RootFlow {
    private var statusMenuController: StatusMenuController?

    required init () {}

    deinit {
        print("deinit")
    }
}

extension RootFlow {
    func loadStatusMenu(statusItem: NSStatusItem) {
        let presenter = StatusMenuPresenter()
        statusMenuController = StatusMenuController(presenter: presenter, statusItem: statusItem)
        statusMenuController?.setup()
    }
}
