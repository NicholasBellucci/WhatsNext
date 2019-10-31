//
//  NotificationViewController.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/6/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation
import Cocoa

class NotificationViewController: NSViewController {

    var abortHandler: AbortModalHandler?

    private var presenter: NotificationPresenter

    private lazy var notificationView: NotificationView = {
        let view = NotificationView()
        view.abortHandler = abortHandler
        return view
    }()

    required init(presenter: NotificationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        guard let viewModel = presenter.eventViewModel else { return }
        notificationView.load(viewModel: viewModel)
        view = notificationView
    }
}

private extension NotificationViewController {

}
