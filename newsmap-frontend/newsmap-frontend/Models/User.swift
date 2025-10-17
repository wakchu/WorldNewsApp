import Foundation

struct User: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var email: String = ""
}
