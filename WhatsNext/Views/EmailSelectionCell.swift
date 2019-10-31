//
//  EmailSelectionCell.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/4/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Cocoa

class EmailSelectionCell: NSTableCellView {

    @IBOutlet private weak var emailSelectionView: NSButton!

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}

extension EmailSelectionCell {
    func load(title: String) {
        emailSelectionView.title = title
    }
}
