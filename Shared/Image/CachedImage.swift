//
//  ImageCache.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 15.12.21.
//

import PersistentCacheKit
import SwiftUI

private enum ImageCache {
    static var cache = PersistentCache<String, Data>()
}

private enum CachedImageDownloader {
    static func getUiImage(from url: URL) async -> UIImage? {
        await getOrDownloadAnImageData(from: url).flatMap(UIImage.init(data:))
    }

    static func getOrDownloadAnImageData(from url: URL) async -> Data? {
        if let cached = ImageCache.cache[url.absoluteString] {
            return cached
        } else if let loaded = await downloadAnImageData(from: url) {
            ImageCache.cache[url.absoluteString] = loaded
            return loaded
        } else {
            return nil
        }
    }

    static func downloadAnImageData(from url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }
}

struct CachedImage: View {
    // MARK: Internal

    let url: URL
    var hasMaxHeight = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(idealHeight: height, maxHeight: height)
            } else {
                Image(systemName: "eye.trianglebadge.exclamationmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(idealHeight: height, maxHeight: height)
            }
        }
        .task {
            isLoading = true
            image = await CachedImageDownloader.getUiImage(from: url)
            isLoading = false
        }
    }

    // MARK: Private

    @State private var isLoading = false
    @State private var image: UIImage?

    private let maxHeight: CGFloat = 250

    private var height: CGFloat? {
        hasMaxHeight ? maxHeight : nil
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(url: URL(string: "")!)
    }
}
