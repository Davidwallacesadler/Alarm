//
//  Alarm.swift
//  Alarm
//
//  Created by David Sadler on 4/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

// Codable -- for coding and decoding stuff for storage/archiving
class Alarm : Equatable, Codable {
    
    // MARK: - Protocol Methods

    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate &&
               lhs.name == rhs.name &&
               lhs.enabled == rhs.enabled
    }
    
    // MARK: - Stored Properties
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    var uuid: String
    
    // MARK: - Computed Properties
    
    var fireTimeAsString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            return dateFormatter.string(from: fireDate)
        }
    }
    
    // MARK: - Initializer
    
    init(fireDate: Date, name: String, enabled: Bool, uuid: String) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
}
