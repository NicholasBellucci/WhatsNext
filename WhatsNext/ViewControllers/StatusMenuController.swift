//
//  StatusMenuController.swift
//  UpNext
//
//  Created by Nicholas Bellucci on 11/3/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa
import EventKit

class StatusMenuController: NSObject {
    private enum Constants {
        static let itemLength: CGFloat = 200
        static let padding: CGFloat = 6
    }

    var size: CGFloat = 0

    private var presenter: StatusMenuPresenter
    private var statusItem: NSStatusItem

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

    required init(presenter: StatusMenuPresenter, statusItem: NSStatusItem) {
        self.presenter = presenter
        self.statusItem = statusItem
        super.init()
    }
}

extension StatusMenuController {
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEvent(_:)), name: NSNotification.Name.EKEventStoreChanged, object: nil)

        statusItem.length = 30
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
            scrollingTextView.widthAnchor.constraint(equalToConstant: 170),
            scrollingTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            scrollingTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollingTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }

    func load(viewModel: StatusMenuViewModel?) {
        guard let viewModel = viewModel else { return }
        statusItem.length = Constants.itemLength

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"

        scrollingTextView.setup(width: Constants.itemLength - 50, string: "\(dateFormatter.string(from: viewModel.date)) - \(viewModel.title)")
    }

    @objc
    func updateEvent(_ sender: NotificationCenter) {
        presenter.load()
    }
}
