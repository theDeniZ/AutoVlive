//
//  UserAuth.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import CoreData
import Foundation

class UserAuth: NSManagedObject, Identifiable {
    // MARK: Public

    @NSManaged public var auth: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAuth> {
        NSFetchRequest<UserAuth>(entityName: "UserAuth")
    }

    // MARK: Internal

    static var allUsersFetchRequest: NSFetchRequest<UserAuth> {
        let request: NSFetchRequest<UserAuth> = UserAuth.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
}

extension UserAuth: UserWithAuth {}
