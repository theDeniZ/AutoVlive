//
//  EmptyNavigationLink.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import SwiftUI

struct EmptyNavigationLink<Content: View, Label: View>: View {
    let content: () -> Content
    let label: () -> Label

    var body: some View {
        ZStack {
            label()

            NavigationLink {
                content()
            } label: {
                EmptyView()
            }.frame(width: 0).opacity(0.0)
        }
    }
}
