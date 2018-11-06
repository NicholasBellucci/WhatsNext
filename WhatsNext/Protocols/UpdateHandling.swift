//
//  UpdateHandling.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/5/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation

typealias UpdateHandler = (_ error: Error?) -> ()

protocol UpdateHandling {
    var updateHandler: UpdateHandler? { get set }
}

protocol Updatable {
    var handleUpdate: UpdateHandler { get }
}
