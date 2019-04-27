//
//  AlarmController.swift
//  Alarm
//
//  Created by David Sadler on 4/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

class AlarmController {
    
    // MARK: - SHARED
    
    static let shared = AlarmController()
    
    // MARK: - INTERNAL PROPERTIES
    
    var alarms: [Alarm] = []
    
    // MARK: - CRUD
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) -> Alarm {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        return newAlarm
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
    }
    
    func deleteAlarm(targetAlarm: Alarm) {
        guard let index = alarms.firstIndex(of: targetAlarm) else { return }
        alarms.remove(at: index)
    }
    
    func toggleEnabled(for alarm: Alarm) {
        if alarm.enabled == true {
            alarm.enabled = false
        } else {
            alarm.enabled = true
        }
    }
    
    // MARK: - MOCK DATA
    
    var mockAlarm: [Alarm] {
        var mockAlarms = [Alarm]()
        let today = Date.init(timeIntervalSinceNow: 0)
        mockAlarms.append(Alarm(fireDate: today, name: "Fucking Alarms", enabled: false))
        mockAlarms.append(Alarm(fireDate: today, name: "Are The Worst", enabled: true))
        return mockAlarms
    }
    
    // MARK: - INITIALIZER
    
    init() {
        self.alarms = self.mockAlarm
    }
    
}
