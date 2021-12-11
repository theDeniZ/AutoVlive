//
//  NotificationManager.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 20.12.21.
//

import SwiftUI

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    // MARK: Internal

    static let shared = NotificationManager()

    func start() {
        requestNotificationAuthorization()
        notificationCetner.delegate = self
    }

    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        notificationCetner.requestAuthorization(options: authOptions) { _, error in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification(_ title: String = "Shiny! 🌤") {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

        let request = UNNotificationRequest(
            identifier: "weather",
            content: notificationContent,
            trigger: trigger
        )

        notificationCetner.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // MARK: Private

    private let notificationCetner = UNUserNotificationCenter.current()
}
