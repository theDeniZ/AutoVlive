//
//  RollingApi.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import Foundation

class UserApiAccessor: ObservableObject {
    // MARK: Lifecycle

    init(userStorage: UserStorage) {
        let userName = UserDefaults.standard.string(forKey: UserApiAccessor.UserDefaultsKey) ?? ""
        currentUser = userStorage.getUser(byName: userName) ?? userStorage.users.first
    }

    // MARK: Internal

    static var shared: UserApiAccessor!

    @Published var currentUser: UserAuth? {
        didSet {
            UserDefaults.standard.set(currentUser?.name ?? "", forKey: UserApiAccessor.UserDefaultsKey)
        }
    }

    func useDefaultUser(_ userStorage: UserStorage) {
        if let currentUser = currentUser, userStorage.users.contains(currentUser) {
            return
        }
        currentUser = userStorage.users.first
    }

    // MARK: Private

    private static let UserDefaultsKey = "UserApiAccessorCurrentUser"
}
