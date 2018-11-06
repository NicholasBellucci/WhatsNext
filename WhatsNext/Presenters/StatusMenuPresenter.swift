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
        guard let event = event else { return nil }
        return StatusMenuViewModel(title: event.title, date: event.startDate)
    }

    var eventStartDate: Date? {
        guard let event = event else { return nil }
        return event.startDate
    }

    var eventEndDate: Date? {
        guard let event = event else { return nil }
        return event.endDate
    }

    private var event: EKEvent? {
        guard let end = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return nil }
        let eventsPredicate = eventStore.predicateForEvents(withStart: Date(), end: end, calendars: calendars)
        let events = eventStore.events(matching: eventsPredicate).sorted { $0.startDate < $1.startDate }
        return events.first(where: { event -> Bool in
            event.isAllDay == false
        })
    }

    required init() {}
}

extension StatusMenuPresenter {
    func load() {
        checkPermission { [weak self] error in
            guard let sself = self else { return }
            sself.calendars = EKEventStore().calendars(for: EKEntityType.event)
            sself.updateHandler?(error)

            let timer = Timer(timeInterval: 60.0, target: sself, selector: #selector(sself.refreshCalendar(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .common)
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

    @objc
    func refreshCalendar(_ timer: Timer) {
        eventStore.refreshSourcesIfNecessary()
    }
}
