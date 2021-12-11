//
//  UserLoginService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.12.21.
//

import AutoVliveApi
import Foundation

class UserLoginService {
    func login(with users: [UserAuth]) async {
        await withTaskGroup(of: Void.self) { taskGroup in
            users.forEach { user in
                taskGroup.addTask {
                    guard !Task.isCancelled else { return }
                    try? await FeedApi.initClient(user: user)
                }
            }
        }
    }
}
