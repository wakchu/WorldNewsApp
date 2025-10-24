import Foundation

struct Country: Identifiable, Codable, Equatable {
    var id: String { isoCode }
    let isoCode: String
    let name: String
    let region: String?
}
