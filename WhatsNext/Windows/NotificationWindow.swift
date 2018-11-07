//
//  NotificationWindow.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

enum WindowPlacement {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center
}

class NotificationWindow: NSWindow {

    private var windowFrame: NSRect
    private var windowPlacement: WindowPlacement

    required init(frame: NSRect, placement: WindowPlacement) {
        windowFrame = frame
        windowPlacement = placement
        super.init(contentRect: frame, styleMask: [.fullSizeContentView], backing: .buffered, defer: false)
    }

    override func center() {
        guard let screen = NSScreen.main else { return }
        var point = NSPoint(x: 0, y: 0)
        let xCoord = screen.visibleFrame.width - windowFrame.width - 20
        let yCoord = screen.visibleFrame.height - windowFrame.height - 20

        switch windowPlacement {
        case .topLeft:
            point.x = 20
            point.y = yCoord
        case .bottomLeft:
            point.x = 20
            point.y = 20
        case .topRight:
            point.x = xCoord
            point.y = yCoord
        case .bottomRight:
            point.x = xCoord
            point.y = 20
        case .center:
            point.x = (screen.visibleFrame.width / 2) - (windowFrame.width / 2)
            point.y = (screen.visibleFrame.height / 2) - (windowFrame.height / 2)
        }

        setFrame(NSRect(x: point.x, y: point.y, width: windowFrame.width, height: windowFrame.height), display: true)
    }
}
