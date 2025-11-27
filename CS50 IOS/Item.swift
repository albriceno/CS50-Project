//
//  Item.swift
//  CS50 IOS
//
//  Created by Olivia Jimenez on 11/25/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
