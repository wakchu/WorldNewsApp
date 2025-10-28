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
    
    var sourceName: String {
        source.name
    }
    
    func toNewsArticleResponse() -> NewsArticleResponse {
        NewsArticleResponse(
            id: id,
            title: title,
            description: description,
            url: url,
            imageUrl: imageUrl,
            publishedAt: publishedAt,
            source: SourceResponse(id: source.id, name: source.name, url: source.url)
        )
    }
}
