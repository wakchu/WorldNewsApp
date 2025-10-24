import Foundation

class UserService {
    private let api = APIService()

    func getMyProfile(token: String) async throws -> User {
        return try await api.get(endpoint: "/api/users/me", token: token)
    }

    func addFavoriteCountry(isoCode: String, token: String) async throws {
        try await api.postEmpty(endpoint: "/api/users/me/countries/\(isoCode)", token: token)
    }

    func removeFavoriteCountry(isoCode: String, token: String) async throws {
        try await api.delete(endpoint: "/api/users/me/countries/\(isoCode)", token: token)
    }

    func addFavoriteNews(newsId: Int, token: String) async throws {
        try await api.postEmpty(endpoint: "/api/users/me/bookmarks/\(newsId)", token: token)
    }

    func removeFavoriteNews(newsId: Int, token: String) async throws {
        try await api.delete(endpoint: "/api/users/me/bookmarks/\(newsId)", token: token)
    }
}
