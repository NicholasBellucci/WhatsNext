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

    var size: CGFloat = 0

    private lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        return statusItem
    }()

    private lazy var windowController: PreferencesWindowController = {
        let windowController = PreferencesWindowController()
        return windowController
    }()

    override func awakeFromNib() {
        statusItem.highlightMode = false
        statusItem.menu = statusMenu
        statusItem.length = 200

        let scrollingText = ScrollingTextView()
        scrollingText.frame = NSRect(x: 0, y: 0, width: 200, height: 40)
        scrollingText.setText(string: "This is a test amount of text plus some more")

        if scrollingText.stringWidth > 195 {
            scrollingText.setSpeed(newInterval: 1)
        }

        let view = statusItem.value(forKey: "window") as? NSWindow
        view?.contentView?.addSubview(scrollingText)
    }

    func startAnimating() {
        let view = statusItem.value(forKey: "window") as? NSWindow
        view?.contentView?.layer = CALayer()
        view?.contentView?.subviews[0].wantsLayer = true
        view?.contentView?.subviews[0].startMarquee(size: size, duration: 7)
    }

    @IBAction func preferencesClicked(_ sender: Any) {
        windowController.showWindow(self)
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}

extension String {
    func widthOfString(usingFont font: NSFont?) -> CGFloat {
        guard let font = font else { return 0 }
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension NSView {
    func startMarquee(size: CGFloat, duration: Double) {
        let kAnimationKey = "position"

        if layer?.animation(forKey: kAnimationKey) == nil {
            let animation = CABasicAnimation(keyPath: "position")
            let startingPoint = NSValue(point: NSPoint(x: size, y: 0))
            let endingPoint = NSValue(point: NSPoint(x: -size, y: 0))
            animation.fromValue = startingPoint
            animation.toValue = endingPoint
            animation.repeatCount = Float.greatestFiniteMagnitude
            animation.duration = duration
            guard let layer = layer else { return }
            layer.add(animation, forKey: "linearMovement")
        }
    }
}
