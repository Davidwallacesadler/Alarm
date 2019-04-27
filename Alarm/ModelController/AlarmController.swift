//
//  AlarmController.swift
//  Alarm
//
//  Created by David Sadler on 4/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    // Provide defualt implementations of the alarmScheduler methods
    // This makes it so we can get these functions for every class that confroms to AlarmScheduler
    // TODO: - Think of how to apply this to the Dice App 3D calculations
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Your \(alarm.name) alarm is going off!"
        content.sound = UNNotificationSound.default
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("There was an error scheduling the notification: \(error)")
            }
        })
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        let alarmID = alarm.uuid
        let userNotifications = UNUserNotificationCenter.current()
        userNotifications.removePendingNotificationRequests(withIdentifiers: [alarmID])
    }
}

class AlarmController : AlarmScheduler {
    
    // MARK: - Shared Instance
    
    static let shared = AlarmController()
    
    // MARK: - Internal Properties
    
    var alarms: [Alarm] = []
    let alphabet = Array<Any>.generateAlphabetArray()
    
    // MARK: - CRUD
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        print("alarm was given id of \(newAlarm.uuid)")
        saveToPersistentStorage()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStorage()
    }
    
    func deleteAlarm(targetAlarm: Alarm) {
        guard let index = alarms.firstIndex(of: targetAlarm) else { return }
        alarms.remove(at: index)
        saveToPersistentStorage()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        if alarm.enabled == true {
            alarm.enabled = false
            cancelUserNotifications(for: alarm)
        } else {
            alarm.enabled = true
            scheduleUserNotifications(for: alarm)
        }
        saveToPersistentStorage()
    }
    
    // MARK: - Initializer
    
    init() {
        loadFromPersistentStorage()
    }
    
    // MARK: - Persistence Methods
    
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "alarms.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch {
            print("There was an error when saving the file: \(error)")
            return
        }
    }
    
    func loadFromPersistentStorage() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            self.alarms = alarms
        } catch {
            print("There was an error when loading the file: \(error)")
            return
        }
    }
}
