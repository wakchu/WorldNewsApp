import SwiftUI
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let userService = UserService()
    private let authService = AuthService()
    private let newsService: NewsService

    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }

    func getMyProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            guard let token = KeychainHelper.standard.read(service: "auth", account: "jwt") else {
                errorMessage = "User not logged in"
                isLoading = false
                return
            }
            let user = try await userService.getMyProfile(token: token)
            self.user = user
        } catch {
            errorMessage = "Error fetching profile: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func addFavoriteCountry(isoCode: String) async {
        guard let token = KeychainHelper.standard.read(service: "auth", account: "jwt") else {
            errorMessage = "User not logged in"
            return
        }

        do {
            try await userService.addFavoriteCountry(isoCode: isoCode, token: token)
            await getMyProfile()
        } catch {
            errorMessage = "Error adding favorite country: \(error.localizedDescription)"
        }
    }

    func removeFavoriteCountry(isoCode: String) async {
        guard let token = KeychainHelper.standard.read(service: "auth", account: "jwt") else {
            errorMessage = "User not logged in"
            return
        }

        do {
            try await userService.removeFavoriteCountry(isoCode: isoCode, token: token)
            await getMyProfile()
        } catch {
            errorMessage = "Error removing favorite country: \(error.localizedDescription)"
        }
    }

    func addFavoriteNews(newsId: Int, token: String?) async {
        guard let token = token ?? KeychainHelper.standard.read(service: "auth", account: "jwt") else {
            errorMessage = "User not logged in"
            return
        }

        do {
            try await userService.addFavoriteNews(newsId: newsId, token: token)
            await getMyProfile()
        } catch {
            errorMessage = "Error adding favorite news: \(error.localizedDescription)"
        }
    }

    func removeFavoriteNews(newsId: Int) async {
        guard let token = KeychainHelper.standard.read(service: "auth", account: "jwt") else {
            errorMessage = "User not logged in"
            return
        }

        do {
            try await userService.removeFavoriteNews(newsId: newsId, token: token)
            await getMyProfile()
        } catch {
            errorMessage = "Error removing favorite news: \(error.localizedDescription)"
        }
    }
}