import Foundation

struct Source: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let url: String?
}
