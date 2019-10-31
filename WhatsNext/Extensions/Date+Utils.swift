//
//  Date+Utils.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

extension Date {
    func add(minutes: CGFloat) -> Date {
        return (self + TimeInterval(60 * minutes))
    }
}
