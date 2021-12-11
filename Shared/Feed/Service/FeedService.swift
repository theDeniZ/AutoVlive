//
//  UserService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import Foundation
import SwiftUI

class FeedService: TaskService, ObservableObject {
    // MARK: Lifecycle

    required init(user: UserAuth? = nil, usingUserApiAccessor: Bool = false) {
        self.user = user
        self.usingUserApiAccessor = usingUserApiAccessor
    }

    // MARK: Internal

    @Published var feed: [FeedItem] = []
    @Published var isLoading = false

    static func create(user: UserAuth?) -> FeedService {
        let service = FeedService(user: user)
        return service
    }

    override func performTask() async {
        await getFeed()
    }

    func getFeed() async {
        guard let user = (user ?? (usingUserApiAccessor ? UserApiAccessor.shared.currentUser : nil)) else {
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
        }

        await userLoginService.login(with: [user])

        do {
            let items = try await FeedApi.getFeedInfo(includeBanners: 1, maxNumOfRows: 30, user: user)
            DispatchQueue.main.async {
                self.feed = items
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    // MARK: Private

    private let userLoginService: UserLoginService = .init()

    private var user: UserAuth?

    private var usingUserApiAccessor: Bool
}
