//
//  EventAlertNotification.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation

protocol EventAlertNotification {
    var name: Notification.Name { get }
}

enum Notifications: String, EventAlertNotification {
    case alert
}
