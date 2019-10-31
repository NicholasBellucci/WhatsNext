//
//  CalendarError.swift
//  WhatsNext
//
//  Created by Nicholas Bellucci on 11/5/18.
//  Copyright © 2018 Nicholas Bellucci. All rights reserved.
//

import Foundation

enum CalendarError: Error {
    case notAllowed
    case denied

    var localizedDescription: String {
        switch self {
        case .notAllowed: return "Access to calendar events is not allowed"
        case .denied: return "Access to calendar events has been denied"
        }
    }
}
