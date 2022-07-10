//
// Created for AdaptyContacts
// by Stewart Lynch on 2022-07-07
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Foundation

enum Level {
    case trial, premium
    
    var max: Int? {
        switch self {
        case .trial:
            return 3
        case .premium:
            return nil
        }
    }
}
