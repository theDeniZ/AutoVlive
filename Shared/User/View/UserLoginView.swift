//
//  UserDetailView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct UserLoginView: View {
    let login: LoginAddressInfo

    var body: some View {
        Text("IP: \(login.ipAddress)")
            .padding()
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView(login: LoginAddressInfo(ipAddress: "0.0.0.0"))
    }
}
