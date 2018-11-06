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
        static let itemLength: CGFloat = 200
        static let widthConstraint: CGFloat = 170
        static let textViewLength: CGFloat = 150
        static let baseLength: CGFloat = 30
        static let padding: CGFloat = 6
    }

    var size: CGFloat = 0

    private var presenter: StatusMenuPresenter
    private var statusItem: NSStatusItem
    private var title: String?

    private lazy var handleUpdate: UpdateHandler = { [weak self] error in
        guard let sself = self else { return }
        if let error = error {
            sself.display(alert: error as? CalendarError)
        }

        self?.load(viewModel: self?.presenter.statusMenuViewModel)
    }

    private lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()

    private lazy var iconImageView: NSImageView = {
        let imageView = NSImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = NSImage(named: "icon")
        imageView.image?.isTemplate = true
        return imageView
    }()

    private lazy var scrollingTextView: ScrollingTextView = {
        let scrollingText = ScrollingTextView()
        scrollingText.translatesAutoresizingMaskIntoConstraints = false
        return scrollingText
    }()

    private lazy var windowController: PreferencesWindowController = {
        let windowController = PreferencesWindowController()
        return windowController
    }()

    private lazy var widthConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: scrollingTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 0)
        constraint.isActive = true
        return constraint
    }()

    required init(presenter: StatusMenuPresenter, statusItem: NSStatusItem) {
        self.presenter = presenter
        self.statusItem = statusItem
        super.init()
    }
}

extension StatusMenuController {
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEvent(_:)), name: NSNotification.Name.EKEventStoreChanged, object: nil)

        statusItem.length = Constants.baseLength
        presenter.updateHandler = handleUpdate
        presenter.load()
        
        loadSubviews()
    }
}

private extension StatusMenuController {
    func loadSubviews() {
        guard let contentView = contentView else { return }
        contentView.addSubview(scrollingTextView)
        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.rightAnchor.constraint(equalTo: scrollingTextView.leftAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - Constants.padding),
            iconImageView.widthAnchor.constraint(equalToConstant: 30)])

        NSLayoutConstraint.activate([
            scrollingTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            scrollingTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollingTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])

    }

    func load(viewModel: StatusMenuViewModel?) {
        guard let viewModel = viewModel else {
            statusItem.length = Constants.baseLength
            widthConstraint.constant = 0
            return
        }

        statusItem.length = Constants.itemLength
        widthConstraint.constant = Constants.widthConstraint

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        title = viewModel.title
        updateTextView(with: "\(dateFormatter.string(from: viewModel.date)) - \(viewModel.title)")
        addTimers()
    }

    func updateTextView(with string: String) {
        scrollingTextView.setup(width: Constants.textViewLength, string: string)
    }

    func addTimers() {
        guard let eventStartDate = presenter.eventStartDate, let eventEndDate = presenter.eventEndDate else { return }
        let startDateTimer = Timer(fireAt: eventStartDate, interval: 0, target: self, selector: #selector(eventStarted(_:)), userInfo: nil, repeats: false)
        let endDateTimer = Timer(fireAt: eventEndDate, interval: 0, target: self, selector: #selector(eventEnded(_:)), userInfo: nil, repeats: false)

        RunLoop.main.add(startDateTimer, forMode: .common)
        RunLoop.main.add(endDateTimer, forMode: .common)
    }

    @objc
    func eventStarted(_ sender: Timer) {
        guard let title = title else { return }
        updateTextView(with: "Current - \(title)")
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
