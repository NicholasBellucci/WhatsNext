//
//  NotificationWindow.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

public enum WindowQuadrant: CaseIterable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center

    var quadrant: NSRect? {
        guard let screen = NSScreen.main else { return nil }
        let width = screen.visibleFrame.width
        let height = screen.visibleFrame.height

        switch self {
        case .topLeft: return NSRect(x: 0, y: height.halved(), width: width.halved(), height: height.halved())
        case .topRight: return NSRect(x: width.halved(), y: height.halved(), width: width.halved(), height: height.halved())
        case .bottomLeft: return NSRect(x: 0, y: 0, width: width.halved(), height: height.halved())
        case .bottomRight: return NSRect(x: width.halved(), y: 0, width: width.halved(), height: height.halved())
        case .center: return nil
        }
    }
}

class NotificationWindow: NSWindow {
    enum Constants {
        static let padding: CGFloat = 20
    }

    private var windowFrame: NSRect
    private var windowPlacement: WindowQuadrant
    private var quadrant: WindowQuadrant = .topRight

    private var snapFrame: NSRect? {
        guard let screen = NSScreen.main else { return nil }
        let xCoord = screen.visibleFrame.width.minus(windowFrame.width).minus(Constants.padding)
        let yCoord = screen.visibleFrame.height.minus(windowFrame.height).minus(Constants.padding)

        switch quadrant {
        case .topLeft: return NSRect(x: Constants.padding , y: yCoord, width: windowFrame.width, height: windowFrame.height)
        case .topRight: return NSRect(x: xCoord, y: yCoord, width: windowFrame.width, height: windowFrame.height)
        case .bottomLeft: return NSRect(x: Constants.padding, y: Constants.padding, width: windowFrame.width, height: windowFrame.height)
        case .bottomRight: return NSRect(x: xCoord, y: Constants.padding, width: windowFrame.width, height: windowFrame.height)
        case .center: return nil
        }
    }

    required init(frame: NSRect, placement: WindowQuadrant) {
        windowFrame = frame
        windowPlacement = placement
        super.init(contentRect: frame, styleMask: [.fullSizeContentView], backing: .buffered, defer: false)
    }

    override func center() {
        guard let screen = NSScreen.main else { return }
        var point = NSPoint(x: 0, y: 0)
        let xCoord = screen.visibleFrame.width.minus(windowFrame.width).minus(Constants.padding)
        let yCoord = screen.visibleFrame.height.minus(windowFrame.height).minus(Constants.padding)

        switch windowPlacement {
        case .topLeft:
            point.x = Constants.padding
            point.y = yCoord
        case .bottomLeft:
            point.x = Constants.padding
            point.y = Constants.padding
        case .topRight:
            point.x = xCoord
            point.y = yCoord
        case .bottomRight:
            point.x = xCoord
            point.y = Constants.padding
        case .center:
            point.x = screen.visibleFrame.width.halved().minus(windowFrame.width.halved())
            point.y = screen.visibleFrame.height.halved().minus(windowFrame.height.halved())
        }

        setFrame(NSRect(x: point.x, y: point.y, width: windowFrame.width, height: windowFrame.height), display: true)
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        checkQuadrant(with: frame.origin)
    }
}

private extension NotificationWindow {
    func checkQuadrant(with point: NSPoint) {
        WindowQuadrant.allCases.forEach {
            guard let quadrant = $0.quadrant else { return }
            if quadrant.contains(point) {
                self.quadrant = $0
                guard let frame = snapFrame else { return }
                setFrame(frame, display: true, animate: true)
            }
        }
    }
}
