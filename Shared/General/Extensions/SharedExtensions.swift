//
//  StringExtensions.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import Foundation

extension Int {
    var shortFormattedString: String {
        SettingsHandler.shared.shortenNumbers ?
            shortFormattedStringUpTillBillions :
            shortFormattedStringWithThousands
    }

    var shortFormattedStringWithThousands: String {
        if self >= 1000 {
            return String(format: "%.2fK", Double(self) / 1000)
        } else {
            return "\(self)"
        }
    }

    var shortFormattedStringUpTillBillions: String {
        let double = Double(self)
        if self >= 100_000_000_000 {
            return String(format: "%.0fB", double / 1_000_000_000)
        } else if self >= 10_000_000_000 {
            return String(format: "%.1fB", double / 1_000_000_000)
        } else if self >= 1_000_000_000 {
            return String(format: "%.2fB", double / 1_000_000_000)
        } else if self >= 100_000_000 {
            return String(format: "%.0fM", double / 1_000_000)
        } else if self >= 10_000_000 {
            return String(format: "%.1fM", double / 1_000_000)
        } else if self >= 1_000_000 {
            return String(format: "%.2fM", double / 1_000_000)
        } else if self >= 100_000 {
            return String(format: "%.0fK", double / 1000)
        } else if self >= 10000 {
            return String(format: "%.1fK", double / 1000)
        } else if self >= 1000 {
            return String(format: "%.2fK", double / 1000)
        } else {
            return "\(self)"
        }
    }
}

extension Formatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

extension URLRequest {
    static func getPrivateServerRequest(path: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://some.other/autovlive/" + path)!)
        request.addValue("11010110100010100101", forHTTPHeaderField: "Authorization")
        return request
    }
}
