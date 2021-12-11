//
//  UserNavigationView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import SwiftUI

struct UserNavigationView: View {
    // MARK: Internal

    let user: UserAuth

    var body: some View {
        VStack {
            AsyncResultView(result: userService.userInfo) { item in
                UserDetailView(user: item)
            }
            .padding()

            AsyncResultView(result: userService.loginInfo) { item in
                UserLoginView(login: item)
            }
            .padding()

            AsyncResultView(result: userService.chemiInfo) { item in
                UserChemiView(chemi: item)
            }
            .padding()
        }
        .navigationTitle(user.name)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                userApiAccessor.currentUser = user
            }, label: {
                Image(systemName: userApiAccessor.currentUser == user ? "star.fill" : "star")
                    .imageScale(.large)
            })
            .padding()
        })
        .task {
            await withTaskGroup(of: Void.self) { taskGroup in
                taskGroup.addTask {
                    await userService.getUserInfo(user)
                }
                taskGroup.addTask {
                    await userService.getLoginInfo(user)
                }
                taskGroup.addTask {
                    await userService.getChemiInfo(user)
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var userService = UserService()
    @ObservedObject private var userApiAccessor = UserApiAccessor.shared
}

struct UserNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        UserNavigationView(user: .init())
    }
}
