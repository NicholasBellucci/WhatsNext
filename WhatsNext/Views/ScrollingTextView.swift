//
//  ScrollingTextView.swift
//  UpNext
//
//  Created by Nicholas Bellucci on 11/5/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa

class ScrollingTextView: NSView {
    var text: NSString?
    var stringWidth: CGFloat = 0
    private var scroller: Timer?
    private var point = NSPoint(x: 0, y: 3)
    private var timeInterval: TimeInterval?

    func setText(string: String) {
        let textFontAttributes = [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: NSColor.white,
            ]

        text = string as NSString
        stringWidth = text?.size(withAttributes: textFontAttributes).width ?? 0
    }

    func setSpeed(newInterval: TimeInterval) {
        if newInterval != timeInterval {
            timeInterval = newInterval
            scroller?.invalidate()
            scroller = nil

            guard let timeInterval = timeInterval else { return }
            if scroller == nil, timeInterval > 0.0, text != nil {
                scroller = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { [weak self] _ in
                    guard let sself = self, let frame = self?.frame else { return }
                    sself.point.x = sself.point.x - 1
                    self?.setNeedsDisplay(frame)
                })
            }
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        let textFontAttributes = [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: NSColor.white,
        ]

        if point.x + stringWidth < 0 {
            self.point.x += stringWidth + 20
        }

        text?.draw(at: point, withAttributes: textFontAttributes)

        if point.x < 0 {
            var otherPoint = point
            otherPoint.x += stringWidth + 20
            text?.draw(at: otherPoint, withAttributes: textFontAttributes)
        }

    }
}
