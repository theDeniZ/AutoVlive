//
//  UserDetailView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct UserDetailView: View {
    let user: UserInfo

    var body: some View {
        VStack {
            Text("User: \(user.id)")
            Text("Seq: \(user.userSequence)")
            Text("Nickname: \(user.nickname)")
            Text("Visited \(user.activityInfo.visitCount) times")
            Text("Played \(user.activityInfo.playCount) videos")
            Text("Posted \(user.activityInfo.likeCount) likes")
            Text("Shared \(user.activityInfo.shareCount) times")
        }
    }
}

// TODO: Fix

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let user = UserInfo(id: "", userSequence: 0, nickname: "", activityInfo: .init(visitCount: 0, likeCount: 0, playCount: 0, shareCount: 0))
        return UserDetailView(user: user)
    }
}
