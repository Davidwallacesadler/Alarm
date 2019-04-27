//
//  Alarm.swift
//  Alarm
//
//  Created by David Sadler on 4/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

// Codable -- for coding and decoding stuff for storage/ archiving
class Alarm : Equatable, Codable {
    
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
    var uuid: String {
        get {
            let alphabet = Array<Any>.generateAlphabetArray()
            var i = 0
            var alarmID = ""
            while i < 3 {
                let randomInteger = Int.random(in: 0...23)
                alarmID.append(alphabet[randomInteger])
                alarmID.append("\(randomInteger)")
                i += 1
            }
            return alarmID
        }
    }
    
    // MARK: - COMPUTED PROPERTIES
    
    var fireTimeAsString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
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
