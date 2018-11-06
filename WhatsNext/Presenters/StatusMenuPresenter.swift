//
//  StatusMenuPresenter.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/5/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import EventKit

class StatusMenuPresenter: UpdateHandling {
    let eventStore = EKEventStore()
    var calendars = [EKCalendar]()

    var updateHandler: UpdateHandler?

    var statusMenuViewModel: StatusMenuViewModel? {
        guard let event = nextEvent else { return nil }
        return StatusMenuViewModel(title: event.title, date: event.startDate)
    }

    private var nextEvent: EKEvent? {
        guard let end = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return nil }
        let eventsPredicate = eventStore.predicateForEvents(withStart: Date(), end: end, calendars: calendars)
        let events = eventStore.events(matching: eventsPredicate).sorted { $0.startDate < $1.startDate }
        return events.first
    }

    required init() {}
}

extension StatusMenuPresenter {
    func load() {
        checkPermission { [weak self] error in
            self?.calendars = EKEventStore().calendars(for: EKEntityType.event)
            self?.updateHandler?(error)
        }
    }
}

private extension StatusMenuPresenter {
    func checkPermission(completion: @escaping (Error?) -> ()) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            completion(nil)
        case .notDetermined:
            eventStore.requestAccess(to: .event) { allowed, error in
                if let error = error {
                    completion(error)
                } else {
                    if allowed {
                        completion(nil)
                    } else {
                        completion(CalendarError.notAllowed)
                    }
                }
            }
        case .restricted, .denied:
            completion(CalendarError.denied)
        }
    }
}
