//
//  UserView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import CoreData
import SwiftUI

/// Encapsulate @Enviroment to @ObservedObject
struct UserView: View {
    @Environment(\.userStorage) var userStorage: UserStorage

    var body: some View {
        InternalUserView(userStorage: userStorage)
    }
}

private struct InternalUserView: View {
    // MARK: Internal

    @ObservedObject var userStorage: UserStorage

    var body: some View {
        NavigationView {
            List {
                ForEach(userStorage.users) { user in
                    NavigationLink {
                        UserNavigationView(user: user)
                    } label: {
                        HStack {
                            Text(user.name)
                            if user == userApiAccessor.currentUser {
                                Spacer()
                                Image(systemName: "star.fill").imageScale(.medium)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("\(userStorage.users.count) Users")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    Task {
                        await userStorage.syncToServer()
                    }
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                })
                .padding()

                Button(action: {
                    Task {
                        await userStorage.syncFromServer()
                    }
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .imageScale(.large)
                })
                .padding()

                Button(action: {
                    showAddSheet = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                })
                .padding()
            })
            .sheet(isPresented: $showAddSheet) {
                AddUserView()
            }
            Text("Select an item")
        }
    }

    // MARK: Private

    @State private var showAddSheet = false

    @ObservedObject private var userService = UserService()
    @ObservedObject private var userApiAccessor = UserApiAccessor.shared

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { userStorage.users[$0] }.forEach { user in
                do {
                    try userStorage.deleteUser(user)
                } catch {
                    fatalError("Could not delete user \(user.name). Error: \(error)")
                }
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environment(\.userStorage, .preview)
    }
}
