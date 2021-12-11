//
//  NavigationView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import SwiftUI

struct TabNavigationView: View {
    var body: some View {
        TabView {
            UserView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Users")
                }
            FeedView()
                .tabItem {
                    Image(systemName: "square.fill.text.grid.1x2")
                    Text("Feed")
                }
            LikeView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Likes")
                }
        }
        .font(.headline)
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
            .environment(\.userStorage, .preview)
            .environment(\.likeService, .preview)
    }
}
