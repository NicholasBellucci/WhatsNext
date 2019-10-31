//
//  RawRepresentable+Notification.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue == String, Self: EventAlertNotification {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}
