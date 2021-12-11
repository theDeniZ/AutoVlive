//
//  ImageGallery.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 16.12.21.
//

import SwiftUI

struct ImageItem: Identifiable {
    let id: String
    let url: URL
}

struct ImageGallery: View {
    let images: [ImageItem]

    var body: some View {
        GeometryReader { proxy in
            TabView {
                ForEach(images) { image in
                    CachedImage(url: image.url, hasMaxHeight: false)
                        .tag(image.id)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding()
            .frame(width: proxy.size.width)
        }
    }
}

struct ImageGallery_Previews: PreviewProvider {
    static var previews: some View {
        ImageGallery(images: [])
    }
}
