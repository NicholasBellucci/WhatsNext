//
//  Timer+Utils.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

extension Timer {
    convenience init(fireAt: Date, target: Any, selector: Selector, repeats: Bool = false) {
        self.init(fireAt: fireAt, interval: 0, target: target, selector: selector, userInfo: nil, repeats: repeats)
    }
}
