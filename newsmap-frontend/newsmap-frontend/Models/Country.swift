import Foundation

struct Country: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
    var code: String = ""
}
