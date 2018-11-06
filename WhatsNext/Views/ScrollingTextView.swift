//
//  ScrollingTextView.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/5/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa

class ScrollingTextView: NSView {
    var text: NSString?
    var stringWidth: CGFloat = 0
    private var timer: Timer?
    private var point = NSPoint(x: 0, y: 3)
    private var timeInterval: TimeInterval?

    func setup(width: CGFloat, string: String) {
        let textFontAttributes = [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: NSColor.headerTextColor,
            ]

        text = string as NSString
        stringWidth = text?.size(withAttributes: textFontAttributes).width ?? 0

        if stringWidth > width {
            setSpeed(newInterval: 0.04)
        } else {
            setSpeed(newInterval: 0.0)
        }

        setNeedsDisplay(NSRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }

    override func draw(_ dirtyRect: NSRect) {
        let textFontAttributes = [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: NSColor.headerTextColor,
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

private extension ScrollingTextView {
    func setSpeed(newInterval: TimeInterval) {
        if newInterval != timeInterval {
            timeInterval = newInterval
            timer?.invalidate()
            timer = nil

            guard let timeInterval = timeInterval else { return }
            if timer == nil, timeInterval > 0.0, text != nil {
                timer = Timer.scheduledTimer(withTimeInterval: newInterval, repeats: true, block: { [weak self] _ in
                    guard let sself = self else { return }
                    sself.point.x = sself.point.x - 1
                    sself.setNeedsDisplay(NSRect(x: 0, y: 0, width: sself.frame.width, height: sself.frame.height))
                })

                guard let timer = timer else { return }
                RunLoop.main.add(timer, forMode: .common)
            } else {
                timer?.invalidate()
                point.x = 0
            }
        }
    }
}
