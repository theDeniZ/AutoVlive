//
//  LikeHistoryItemView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.01.22.
//

import SwiftUI

struct LikeHistoryItemView: View {
    var history: LikeHistory

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text(history.video)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .layoutPriority(100)

                        Text(history.date as Date, format: .dateTime)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Spacer()

                    VStack {
                        HStack {
                            Image(systemName: "heart")
                            Text(Int(history.likesPosted).shortFormattedString)
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

struct LikeHistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        let history = LikeHistory(context: PersistenceController.preview.container.viewContext)
        history.video = "abc video here"
        history.date = Date.now as NSDate
        history.likesPosted = 12345
        return LikeHistoryItemView(history: history)
    }
}
