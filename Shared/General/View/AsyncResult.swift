//
//  AsyncResult.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import SwiftUI

enum AsyncResult<Success> {
    case empty
    case inProgress
    case success(Success)
    case failure(Error)
}

struct AsyncResultView<Success, Content: View>: View {
    let result: AsyncResult<Success>
    let content: (_ item: Success) -> Content

    var body: some View {
        switch result {
        case .empty:
            Text("")
        case .inProgress:
            ProgressView()
        case let .success(value):
            content(value)
        case let .failure(error):
            Text("Error: \(error.localizedDescription)")
        }
    }
}
