import Foundation

struct NewsArticle: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String = ""
}
