//
//  Alarm.swift
//  Alarm
//
//  Created by David Sadler on 4/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

class Alarm : Equatable {
    
    // MARK: - PROTOCOL STUBS
    
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate &&
               lhs.name == rhs.name &&
               lhs.enabled == rhs.enabled
    }
    
    // MARK: - STORED PROPERTIES
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    //let uuid: String
    
    // MARK: - COMPUTED PROPERTIES
    
    var fireTimeAsString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            return dateFormatter.string(from: fireDate)
        }
    }
    
    // MARK: - INITIALIZER
    
    init(fireDate: Date, name: String, enabled: Bool) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
    }
}
