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
        print("FavoritesViewModel: getMyProfile called.")
        isLoading = true
        errorMessage = nil

        do {
            guard let token = KeychainHelper.standard.read(service: "auth", account: "jwt") else {
                errorMessage = "User not logged in"
                isLoading = false
                print("FavoritesViewModel: getMyProfile - User not logged in.")
                return
            }
            let user = try await userService.getMyProfile(token: token)
            self.user = user
            print("FavoritesViewModel: getMyProfile - User profile updated. Favorite countries count: \(user.favoriteCountries.count)")
        } catch {
            errorMessage = "Error fetching profile: \(error.localizedDescription)"
            print("FavoritesViewModel: getMyProfile - Error: \(error.localizedDescription)")
        }

        isLoading = false
    }

    func addFavoriteCountry(isoCode: String, token: String?) async {
        print("FavoritesViewModel: addFavoriteCountry called for \(isoCode).")
        guard let token = token ?? KeychainHelper.standard.read(service: "auth", account: "jwt") else {
            errorMessage = "User not logged in"
            print("FavoritesViewModel: addFavoriteCountry - User not logged in.")
            return
        }

        do {
            try await userService.addFavoriteCountry(isoCode: isoCode, token: token)
            print("FavoritesViewModel: addFavoriteCountry - Successfully added \(isoCode). Refreshing profile.")
            await getMyProfile()
        } catch {
            errorMessage = "Error adding favorite country: \(error.localizedDescription)"
            print("FavoritesViewModel: addFavoriteCountry - Error: \(error.localizedDescription)")
        }
    }

    func removeFavoriteCountry(isoCode: String, token: String?) async {
        print("FavoritesViewModel: removeFavoriteCountry called for \(isoCode).")
        guard let token = token ?? KeychainHelper.standard.read(service: "auth", account: "jwt") else {
            errorMessage = "User not logged in"
            print("FavoritesViewModel: removeFavoriteCountry - User not logged in.")
            return
        }

        do {
            try await userService.removeFavoriteCountry(isoCode: isoCode, token: token)
            print("FavoritesViewModel: removeFavoriteCountry - Successfully removed \(isoCode). Refreshing profile.")
            await getMyProfile()
        } catch {
            errorMessage = "Error removing favorite country: \(error.localizedDescription)"
            print("FavoritesViewModel: removeFavoriteCountry - Error: \(error.localizedDescription)")
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

    func removeFavoriteNews(newsId: Int, token: String?) async {
        guard let token = token ?? KeychainHelper.standard.read(service: "auth", account: "jwt") else {
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