//
//  UserStorage.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import CoreData
import Foundation
import SwiftUI

enum UserError: Error {
    case userNameIsEmpty
    case userAuthIsEmpty
    case couldNotSaveUser(String)
    case couldNotDeleteUser(String)
    case userNameAlreadyExists
    case userAuthAlreadyExists
}

class UserStorage: NSObject, ObservableObject {
    // MARK: Lifecycle

    override init() {
        userController = NSFetchedResultsController()

        super.init()
    }

    init(context: NSManagedObjectContext) {
        userController = NSFetchedResultsController(
            fetchRequest: UserAuth.allUsersFetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        userController.delegate = self

        do {
            try userController.performFetch()
            users = (userController.fetchedObjects ?? []).shuffled()
        } catch {
            print("failed to fetch items!")
        }
    }

    // MARK: Internal

    static var shared: UserStorage?

    @Published var users: [UserAuth] = []

    func getUser(byName name: String) -> UserAuth? {
        users.first(where: { $0.name == name })
    }

    func getUser(byAuth auth: String) -> UserAuth? {
        users.first(where: { $0.auth == auth })
    }

    func createUser(name: String, auth: String) throws {
        guard !name.isEmpty else { throw UserError.userNameIsEmpty }
        guard !auth.isEmpty else { throw UserError.userAuthIsEmpty }
        guard getUser(byName: name) == nil else { throw UserError.userNameAlreadyExists }
        guard getUser(byAuth: auth) == nil else { throw UserError.userAuthAlreadyExists }

        let user = UserAuth(context: userController.managedObjectContext)
        user.name = name
        user.auth = auth
        user.id = UUID()
        do {
            try userController.managedObjectContext.save()
        } catch {
            throw UserError.couldNotSaveUser(error.localizedDescription)
        }
    }

    func deleteUser(_ user: UserAuth) throws {
        var shouldUpdateCurrentUser = false
        if UserApiAccessor.shared.currentUser == user {
            shouldUpdateCurrentUser = true
        }

        userController.managedObjectContext.delete(user)

        do {
            try userController.managedObjectContext.save()
        } catch {
            throw UserError.couldNotDeleteUser(error.localizedDescription)
        }
        if shouldUpdateCurrentUser {
            UserApiAccessor.shared.useDefaultUser(self)
        }
    }

    func getUsers(_ filter: (UserAuth) async -> Bool) async -> [UserAuth] {
        var result = [UserAuth]()
        for user in users where await filter(user) {
            result.append(user)
            if result.count >= maxUsersAtOnce {
                return result
            }
        }
        return result
    }

    // MARK: Private

    private let userController: NSFetchedResultsController<UserAuth>

    // MARK: Packs of users

    private var maxUsersAtOnce: Int {
        SettingsHandler.shared.usersAtOnce
    }
}

extension UserStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let fetchedItems = controller.fetchedObjects as? [UserAuth] else { return }
        DispatchQueue.main.async { [weak self] in
            self?.users = fetchedItems
        }
    }
}

extension UserStorage {
    func syncFromServer() async {
        var request = URLRequest.getPrivateServerRequest(path: "users")
        request.method = .get
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(response.description)

            let usersDTO = try? JSONDecoder().decode([InternalUserDTO].self, from: data)
            usersDTO.flatMap { [weak self] in
                print("Users Received: \($0.count)")
                self?.addAllUsers($0)
                self.flatMap(UserApiAccessor.shared.useDefaultUser(_:))
            }
        } catch {
            print("Sync Error: \(error)")
        }
    }

    func syncToServer() async {
        var request = URLRequest.getPrivateServerRequest(path: "users")
        request.method = .post
        request.httpBody = try! JSONEncoder().encode(getAllUsers())
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            print(response.description)
        } catch {
            print("Sync Error: \(error)")
        }
    }

    func getAllUsers() -> [InternalUserDTO] {
        users.map { InternalUserDTO(userId: $0.name, userAuth: $0.auth) }
    }

    func addAllUsers(_ usersToAdd: [InternalUserDTO]) {
        usersToAdd.forEach {
            do {
                try createUser(name: $0.userId, auth: $0.userAuth)
            } catch {
                print("Add user \($0.userId) failed: \(error.localizedDescription)")
            }
        }
    }

    func clearDB() {
        users.forEach {
            try? deleteUser($0)
        }
    }
}
