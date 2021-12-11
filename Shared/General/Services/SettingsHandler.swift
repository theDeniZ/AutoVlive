//
//  SettingsHandler.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 19.12.21.
//

import Foundation

class SettingsHandler {
    // MARK: Lifecycle

    init() {
        let appDefaults = [String: AnyObject]()
        defaults.register(defaults: appDefaults)

        prepareSettings()

        NotificationCenter.default.addObserver(self, selector: #selector(updateDefaults), name: UserDefaults.didChangeNotification, object: nil)
        updateDefaults()
    }

    // MARK: Internal

    static let shared = SettingsHandler()

    var usersAtOnce: Int = 10
    var thunderAvailable: Bool = false
    var shortenNumbers = false

    // MARK: Private

    private let defaults: UserDefaults = .standard

    @objc private func updateDefaults() {
        let usersCount = defaults.integer(forKey: "users_at_once")
        usersAtOnce = usersCount > 0 ? usersCount : usersAtOnce
        thunderAvailable = defaults.bool(forKey: "thunder_available")
        shortenNumbers = defaults.bool(forKey: "shorten_numbers")
    }

    private func prepareSettings() {
        if defaults.integer(forKey: "users_at_once") == 0 {
            defaults.set(10, forKey: "users_at_once")
        }
    }
}
