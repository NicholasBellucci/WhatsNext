//
//  StatusMenuController.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/3/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa
import EventKit

class StatusMenuController: NSObject {
    private enum Constants {
        static let statusItemIconLength: CGFloat = 30
        static let statusItemLength: CGFloat = 250
    }

    var size: CGFloat = 0

    private var presenter: StatusMenuPresenter
    private var statusItem: NSStatusItem
    private var title: String?
    private var alertTimer: Timer?
    private var startDateTimer: Timer?
    private var endDateTimer: Timer?

    private lazy var handleUpdate: UpdateHandler = { [weak self] error in
        guard let sself = self else { return }
        if let error = error {
            sself.display(alert: error as? CalendarError)
        }

        self?.load(viewModel: self?.presenter.eventViewModel)
    }

    private lazy var windowController: PreferencesWindowController = {
        let windowController = PreferencesWindowController()
        return windowController
    }()

    private lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()

    private lazy var scrollingStatusItemView: ScrollingStatusItemView = {
        let view = ScrollingStatusItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = NSImage(named: "icon")
        view.lengthHandler = handleLength
        return view
    }()

    private lazy var handleLength: StatusItemLengthUpdate = { length in
        if length < Constants.statusItemLength {
            self.statusItem.length = length
        } else {
            self.statusItem.length = Constants.statusItemLength
        }
    }

    required init(presenter: StatusMenuPresenter, statusItem: NSStatusItem) {
        self.presenter = presenter
        self.statusItem = statusItem
        super.init()
    }
}

extension StatusMenuController {
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEvent(_:)), name: NSNotification.Name.EKEventStoreChanged, object: nil)

        statusItem.length = Constants.statusItemIconLength
        presenter.updateHandler = handleUpdate
        presenter.load()
        
        loadSubviews()
    }
}

private extension StatusMenuController {
    func loadSubviews() {
        guard let contentView = contentView else { return }
        contentView.addSubview(scrollingStatusItemView)

        NSLayoutConstraint.activate([
            scrollingStatusItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollingStatusItemView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            scrollingStatusItemView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            scrollingStatusItemView.heightAnchor.constraint(equalToConstant: 22)])

    }

    func load(viewModel: EventViewModel?) {
        guard let viewModel = viewModel else {
            statusItem.length = Constants.statusItemIconLength
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        title = viewModel.title
        scrollingStatusItemView.text = "\(dateFormatter.string(from: viewModel.date)) - \(viewModel.title)"
        clearTimers()
        addTimers()
    }

    func addTimers() {
        guard let eventStartDate = presenter.eventStartDate, let eventEndDate = presenter.eventEndDate else { return }
        let reminderDate = eventStartDate.add(minutes: -10)
        alertTimer = Date() < reminderDate ? Timer(fireAt: reminderDate, target: self, selector: #selector(eventReminder(_:))) : nil
        startDateTimer = Timer(fireAt: eventStartDate, target: self, selector: #selector(eventStarted(_:)))
        endDateTimer = Timer(fireAt: eventEndDate, target: self, selector: #selector(eventEnded(_:)))
    }

    func clearTimers() {
        alertTimer?.invalidate()
        startDateTimer?.invalidate()
        endDateTimer?.invalidate()

        alertTimer = nil
        startDateTimer = nil
        endDateTimer = nil
    }

    @objc
    func eventReminder(_ sender: Timer) {
        NotificationCenter.default.post(name: Notifications.alert.name, object: presenter.currentEvent())
    }

    @objc
    func eventStarted(_ sender: Timer) {
        guard let title = title else { return }
        scrollingStatusItemView.text = "Current - \(title)"
    }

    @objc
    func eventEnded(_ sender: Timer) {
        presenter.load()
    }

    @objc
    func updateEvent(_ sender: NotificationCenter) {
        presenter.load()
    }
}
