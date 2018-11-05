//
//  PreferencesViewController.swift
//  UpNext
//
//  Created by Nicholas Bellucci on 11/3/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa
import EventKit

class PreferencesViewController: NSViewController {

    let eventStore = EKEventStore()
    var calendars = [EKCalendar]()
    var events = [EKEvent]()

    override func viewDidLoad() {
        
    }
}

private extension PreferencesViewController {
    func checkPermission() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            calendars = EKEventStore().calendars(for: EKEntityType.event)
        case .notDetermined:
            eventStore.requestAccess(to: .event) { [weak self] allowed, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if allowed {
                        self?.calendars = EKEventStore().calendars(for: EKEntityType.event)
                    } else {
                        print("Not allowed")
                    }
                }
            }
        case .restricted, .denied:
            print("...")
        }
    }
}

extension PreferencesViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {
        let cell = cell as? EmailSelectionCell
        cell?.load(title: calendars[row].title)
    }
}

extension PreferencesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 5
    }
}
