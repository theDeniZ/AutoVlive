//
//  LikeHistoryStorage.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.01.22.
//

import CoreData
import SwiftUI

enum LikeHistoryStorageError: Error {
    case couldNotSaveHistoryItem(String)
    case historyItemAlreadyExists
}

class LikeHistoryStorage: NSObject, ObservableObject {
    // MARK: Lifecycle

    override init() {
        historyController = NSFetchedResultsController()
        super.init()
    }

    init(context: NSManagedObjectContext) {
        historyController = NSFetchedResultsController(
            fetchRequest: LikeHistory.allHistoryFetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()

        historyController.delegate = self
        do {
            try historyController.performFetch()
            history = historyController.fetchedObjects ?? []
        } catch {
            print("Could not fetch history!")
        }
    }

    // MARK: Public

    public static var shared: LikeHistoryStorage!

    // MARK: Internal

    @Published var history: [LikeHistory] = []

    func addHistoryItem(video: String, likes: Int, date: Date = Date.now) throws {
        guard !history.contains(where: { $0.video == video && $0.likesPosted == likes }) else {
            throw LikeHistoryStorageError.historyItemAlreadyExists
        }

        let historyItem = LikeHistory(context: historyController.managedObjectContext)
        historyItem.id = UUID()
        historyItem.video = video
        historyItem.likesPosted = Int32(likes)
        historyItem.date = date as NSDate
        do {
            try historyController.managedObjectContext.save()
        } catch {
            throw LikeHistoryStorageError.couldNotSaveHistoryItem(error.localizedDescription)
        }
    }

    // MARK: Private

    private let historyController: NSFetchedResultsController<LikeHistory>
}

extension LikeHistoryStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let fetchedItems = controller.fetchedObjects as? [LikeHistory] else { return }
        DispatchQueue.main.async { [weak self] in
            self?.history = fetchedItems
        }
    }
}

struct InternalHistoryDTO: Codable, Hashable {
    // MARK: Lifecycle

    public init(video: String, likesPosted: Int, date: Date) {
        self.video = video
        self.likesPosted = likesPosted
        self.date = date
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        video = try container.decode(String.self, forKey: .video)
        likesPosted = try container.decode(Int.self, forKey: .likesPosted)
        let timestamp = try container.decode(TimeInterval.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestamp)
    }

    // MARK: Public

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case video
        case likesPosted
        case date
    }

    public var video: String
    public var likesPosted: Int
    public var date: Date

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(video, forKey: .video)
        try container.encode(likesPosted, forKey: .likesPosted)
        try container.encode(date.timeIntervalSince1970, forKey: .date)
    }
}

extension LikeHistoryStorage {
    func syncFromServer() async {
        var request = URLRequest.getPrivateServerRequest(path: "history")
        request.method = .get
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(response.description)

            let historyDTO = try? JSONDecoder().decode([InternalHistoryDTO].self, from: data)
            historyDTO.flatMap { [weak self] in
                print("History Received: \($0.count)")
                self?.addAllHistory($0)
            }
        } catch {
            print("Sync Error: \(error)")
        }
    }

    func syncToServer() async {
        var request = URLRequest.getPrivateServerRequest(path: "history")
        request.method = .post
        request.httpBody = try! JSONEncoder().encode(getAllHistory())
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            print(response.description)
        } catch {
            print("Sync Error: \(error)")
        }
    }

    func getAllHistory() -> [InternalHistoryDTO] {
        history.map { InternalHistoryDTO(video: $0.video, likesPosted: Int($0.likesPosted), date: $0.date as Date) }
    }

    func addAllHistory(_ historyToAdd: [InternalHistoryDTO]) {
        historyToAdd.forEach {
            do {
                try addHistoryItem(video: $0.video, likes: $0.likesPosted, date: $0.date)
            } catch {
                print("Add history for video \($0.video) with likes \($0.likesPosted) failed: \(error.localizedDescription)")
            }
        }
    }
}
