//
//  LikeItemView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import SwiftUI

struct LikeItemView: View {
    @ObservedObject var likeJob: LikeJob

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text(likeJob.title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .layoutPriority(100)
                    }

                    Spacer()

                    VStack {
                        Image(systemName: likeJob.status.systemImageName)
                            .imageScale(.large)
                            .padding()
                        HStack {
                            Image(systemName: "heart")
                            Text(likeJob.likesPosted.shortFormattedString)
                        }
                    }
                    .layoutPriority(100)
                }
            }
            .padding()
            .layoutPriority(100)

            Spacer()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.2), lineWidth: 2)
        )
        .padding([.top, .horizontal])
    }
}

struct LikeItemView_Previews: PreviewProvider {
    static var previews: some View {
        let like = LikeJob(title: "test of some long title here goes here one two three four ", video: 123, isLive: false)
        like.likesPosted = 1_234_567
        like.status = .thunder
        return LikeItemView(likeJob: like)
    }
}
