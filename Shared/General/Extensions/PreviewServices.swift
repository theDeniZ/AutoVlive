//
//  PreviewServices.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 15.12.21.
//

import Foundation

extension UserStorage {
    static let preview = UserStorage(context: PersistenceController.preview.container.viewContext)
}

extension LikeService {
    static let preview = LikeService(.preview)
}
