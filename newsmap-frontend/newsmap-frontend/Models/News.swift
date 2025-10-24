import Foundation

struct News: Identifiable, Codable, Equatable {
    let id: Int
    let source: Source
    let title: String
    let description: String?
    let url: String
    let imageUrl: String?
    let publishedAt: String
    let countries: [Country]
}