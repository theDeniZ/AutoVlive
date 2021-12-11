//
//  UserService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import Foundation

enum UserServiceError: Error {
    case unknownError
}

class UserService: ObservableObject {
    @Published var userInfo: AsyncResult<UserInfo> = .empty
    @Published var loginInfo: AsyncResult<LoginAddressInfo> = .empty
    @Published var chemiInfo: AsyncResult<ChemiStatus> = .empty

    func getUserInfo(_ user: UserAuth) async {
        DispatchQueue.main.async {
            self.userInfo = .inProgress
        }
        do {
            let userInfo = try await UserApi.getUserInfo(user: user)
            DispatchQueue.main.async {
                self.userInfo = .success(userInfo)
            }
        } catch {
            DispatchQueue.main.async {
                self.userInfo = .failure(error)
            }
        }
    }

    func getLoginInfo(_ user: UserAuth) async {
        await UserLoginService().login(with: [user])
        DispatchQueue.main.async {
            self.loginInfo = .inProgress
        }
        do {
            let login = try await FeedApi.checkLogin(user: user)
            DispatchQueue.main.async {
                self.loginInfo = .success(login)
            }
        } catch {
            DispatchQueue.main.async {
                self.loginInfo = .failure(error)
            }
        }
    }

    func getChemiInfo(_ user: UserAuth) async {
        DispatchQueue.main.async {
            self.chemiInfo = .inProgress
        }
        do {
            let info = try await ChemiApi.getChemiInfo(user: user)
            DispatchQueue.main.async {
                self.chemiInfo = .success(info)
            }
        } catch {
            DispatchQueue.main.async {
                self.chemiInfo = .failure(error)
            }
        }
    }
}
