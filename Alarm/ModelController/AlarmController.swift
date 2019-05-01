//
//  AlarmController.swift
//  Alarm
//
//  Created by David Sadler on 4/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController : AlarmScheduler {
    
    // MARK: - Shared Instance
    
    static let shared = AlarmController()
    
    // MARK: - Internal Properties
    
    var alarms: [Alarm] = []
    
    // MARK: - CRUD
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        var uuid: String {
                let alphabet = Array<Any>.alaphabetArray
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
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled, uuid: uuid)
        alarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        print("Alarm '\(newAlarm.name)', uuid: \(newAlarm.uuid), fireDate: \(newAlarm.fireTimeAsString), enabled: \(newAlarm.enabled)")
        saveToPersistentStorage()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistentStorage()
    }
    
    func deleteAlarm(targetAlarm: Alarm) {
        guard let index = alarms.firstIndex(of: targetAlarm) else { return }
        alarms.remove(at: index)
        cancelUserNotifications(for: targetAlarm)
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

// MARK: - AlarmScheduler protocol/extension

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Your '\(alarm.name)' alarm is going off!"
        content.sound = UNNotificationSound.default
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("There was an error scheduling the notification: \(error)")
            }
        })
        print("UserNotificationCenter added the notification for alarm: '\(alarm.name)' with uuid: \(alarm.uuid)")
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        let alarmID = alarm.uuid
        let userNotifications = UNUserNotificationCenter.current()
        userNotifications.removePendingNotificationRequests(withIdentifiers: [alarmID])
        print("Alarm:'\(alarm.name)' with uuid:\(alarmID) had its notification request removed!")
    }
}
