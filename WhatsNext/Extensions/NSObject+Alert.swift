//
//  NSObject+Alert.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/5/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa

extension NSObject {
    func display(alert error: CalendarError?) {
        if let error = error {
            let alert = NSAlert(error: error)
            alert.messageText = error.localizedDescription
            alert.runModal()
        }
    }
}
