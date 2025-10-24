import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let username: String
    let email: String?
    let favoriteCountries: [Country]
    let favoriteNews: [News]
}
