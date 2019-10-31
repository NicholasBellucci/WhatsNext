//
//  NotificationView.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/6/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

class NotificationView: NSView {

    var abortHandler: AbortModalHandler?

    private lazy var blurBackground: NSVisualEffectView = {
        let view = NSVisualEffectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.cornerRadius = 8
        view.blendingMode = .behindWindow
        view.material = .appearanceBased
        view.state = .active
        return view
    }()

    private lazy var iconImageView: NSImageView = {
        let image = NSImage(named: "IconGreen")
        let imageView = NSImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        return imageView
    }()

    private lazy var eventTextView: ScrollingTextView = {
        let textView = ScrollingTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = NSFont.systemFont(ofSize: 13)
        return textView
    }()

    private lazy var eventTimeTextView: ScrollingTextView = {
        let textView = ScrollingTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = NSFont.systemFont(ofSize: 11)
        textView.setup(string: "10 mins")
        return textView
    }()

    private lazy var dismissButton: NSButton = {
        let button = NSButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        button.contentTintColor = .white
        button.title = "Dismiss"
        button.target = self
        button.action = #selector(dismissAction(_:))
        return button
    }()

    required init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationView {
    func load(viewModel: EventViewModel) {
        eventTextView.setup(string: viewModel.title)
    }
}

private extension NotificationView {
    func setup() {
        wantsLayer = true
        layer?.cornerRadius = 8

        loadSubviews()
    }

    func loadSubviews() {
        addSubview(blurBackground)
        blurBackground.addSubview(iconImageView)
        blurBackground.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            blurBackground.leftAnchor.constraint(equalTo: leftAnchor),
            blurBackground.rightAnchor.constraint(equalTo: rightAnchor),
            blurBackground.topAnchor.constraint(equalTo: topAnchor),
            blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor)])

        NSLayoutConstraint.activate([
            iconImageView.leftAnchor.constraint(equalTo: blurBackground.leftAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: blurBackground.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35)])

        let stack = NSStackView(views: [eventTextView, eventTimeTextView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .left
        stack.orientation = .vertical
        stack.spacing = 2

        blurBackground.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            stack.rightAnchor.constraint(equalTo: dismissButton.leftAnchor, constant: -10),
            stack.centerYAnchor.constraint(equalTo: blurBackground.centerYAnchor)])

        NSLayoutConstraint.activate([
            eventTextView.heightAnchor.constraint(equalToConstant: 25),
            eventTextView.widthAnchor.constraint(equalToConstant: 210)])

        NSLayoutConstraint.activate([
            eventTimeTextView.heightAnchor.constraint(equalToConstant: 15),
            eventTimeTextView.widthAnchor.constraint(equalToConstant: 50)])

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: blurBackground.topAnchor),
            dismissButton.rightAnchor.constraint(equalTo: blurBackground.rightAnchor, constant: -10),
            dismissButton.bottomAnchor.constraint(equalTo: blurBackground.bottomAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 50)])
    }

    @objc
    func dismissAction(_ sender: NSButton) {
        abortHandler?()
    }
}
