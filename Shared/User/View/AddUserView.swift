//
//  AddUserView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import SwiftUI

struct AddUserView: View {
    // MARK: Internal

    @Environment(\.userStorage) var userStorage: UserStorage
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("User Name", text: $userName)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onChange(of: userName, perform: { value in
                            if value.isEmpty {
                                userNameError = "Should not be empty"
                            } else if let _ = userStorage.getUser(byName: value) {
                                userNameError = "Already exists!"
                            } else {
                                userNameError = ""
                            }
                        })
                    if !userNameError.isEmpty {
                        Text(userNameError)
                    }
                }

                Section(header: Text("Auth")) {
                    TextField("User Auth", text: $userAuth)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onChange(of: userAuth, perform: { value in
                            if value.isEmpty {
                                userAuthError = "Should not be empty"
                            } else if let _ = userStorage.getUser(byAuth: value) {
                                userAuthError = "Already exists!"
                            } else {
                                userAuthError = ""
                            }
                        })
                    if !userAuthError.isEmpty {
                        Text(userAuthError)
                    }
                }

                if !otherError.isEmpty {
                    Text(otherError)
                }

                Button(action: {
                    addUser()
                }) {
                    Text("Add User")
                }
                .disabled(!hasState || hasError)
            }
            .navigationTitle("Add User")
        }
    }

    // MARK: Private

    @State private var userName = ""
    @State private var userAuth = ""

    @State private var userNameError = ""
    @State private var userAuthError = ""
    @State private var otherError = ""

    private var hasState: Bool {
        !userName.isEmpty && !userAuth.isEmpty
    }

    private var hasError: Bool {
        !userNameError.isEmpty || !userAuthError.isEmpty
    }

    private func addUser() {
        do {
            try userStorage.createUser(name: userName, auth: userAuth)
            presentationMode.wrappedValue.dismiss()
        } catch {
            switch error {
            case UserError.userNameIsEmpty:
                userNameError = "Should not be empty"
            case UserError.userAuthIsEmpty:
                userAuthError = "Should not be empty"
            case let UserError.couldNotSaveUser(message):
                otherError = "Unexpected error: \(message)"
            default:
                otherError = "Unexpected error"
            }
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
            .environment(\.userStorage, .preview)
    }
}
