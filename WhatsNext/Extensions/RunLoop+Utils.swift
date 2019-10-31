//
//  RunLoop+Utils.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

extension RunLoop {
    func add(_ timers: [Timer?], forMode: RunLoop.Mode) {
        for timer in timers {
            guard let timer = timer else { continue }
            self.add(timer, forMode: .common)
        }
    }
}
