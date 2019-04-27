//
//  AppDelegate.swift
//  Alarm
//
//  Created by David Sadler on 4/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import UserNotifications

// Needed to adopt to UNUserNotificationCenterDelegate in order to show notifications when the user is in the app.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        let options : UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) {
            (accepted, error) in
            if !accepted {
                print("Notification access has been denied")
            }
        }
    UNUserNotificationCenter.current().delegate = self
    return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }


}

