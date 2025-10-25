import Foundation

struct NewsArticleResponse: Decodable {
    let id: Int
    let title: String
    let description: String?
    let url: String
    let imageUrl: String?
    let publishedAt: String
    let sourceName: String
}

class NewsService {
    
    private let api = APIService()
    
    // Carica le notizie principali di un paese
    func getTopHeadlines(for countryCode: String, token: String? = nil) async throws -> [NewsArticleResponse] {
        // Costruisce l'endpoint: /news?country=IT
        let queryItems = [URLQueryItem(name: "country", value: countryCode)]
        return try await api.get(endpoint: "/news", queryItems: queryItems, token: token)
    }

    func getNews(for isoCode: String, token: String? = nil) async throws -> [NewsArticleResponse] {
        return try await api.get(endpoint: "/api/news/by-country/\(isoCode)", token: token)
    }

    func fetchNews(for isoCode: String, token: String? = nil) async throws {
        try await api.postEmpty(endpoint: "/api/fetch-news/\(isoCode)", token: token)
    }
    
    // Dettaglio articolo singolo
    func getArticle(by id: Int, token: String? = nil) async throws -> NewsArticleResponse {
        return try await api.get(endpoint: "/news/\(id)", token: token)
    }
}
