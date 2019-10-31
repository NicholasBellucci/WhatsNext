//
//  NotificationPresenter.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/7/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import EventKit

class NotificationPresenter: UpdateHandling {
    var updateHandler: UpdateHandler?
    
    var eventViewModel: EventViewModel? {
        return EventViewModel(title: event.title, date: event.startDate)
    }

    private var event: EKEvent

    required init(event: EKEvent) {
        self.event = event
    }
}
