import SwiftUI
import Combine

struct FavoriteCountryResponse: Decodable {
    let code: String
    let name: String
    let latitude: Double
    let longitude: Double
}

struct FavoriteArticleResponse: Decodable {
    let id: Int
    let title: String
    let description: String?
    let url: String
    let imageUrl: String?
    let publishedAt: String
    let sourceName: String
}

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteCountries: [FavoriteCountryResponse] = []
    @Published var favoriteArticles: [FavoriteArticleResponse] = []
    
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    // MARK: - Carica i paesi preferiti dell'utente
    func loadFavoriteCountries(token: String) async {
        do {
            let countries: [FavoriteCountryResponse] = try await apiService.get(endpoint: "/users/me/favorites/countries", token: token)
            self.favoriteCountries = countries
        } catch {
            print("Errore caricamento paesi preferiti: \(error)")
            self.favoriteCountries = []
        }
    }
    
    // MARK: - Carica gli articoli preferiti dell'utente
    func loadFavoriteArticles(token: String) async {
        do {
            let articles: [FavoriteArticleResponse] = try await apiService.get(endpoint: "/users/me/favorites/articles", token: token)
            self.favoriteArticles = articles
        } catch {
            print("Errore caricamento articoli preferiti: \(error)")
            self.favoriteArticles = []
        }
    }
    
    // MARK: - Aggiungi o rimuovi un paese preferito
    func toggleFavoriteCountry(_ countryCode: String, token: String) async {
        do {
            // Chiama PUT per aggiungere/rimuovere
            let _: [FavoriteCountryResponse] = try await apiService.put(endpoint: "/users/me/favorites/countries", body: ["countryCode": countryCode], token: token)
            await loadFavoriteCountries(token: token)
        } catch {
            print("Errore toggle paese preferito: \(error)")
        }
    }
    
    // MARK: - Aggiungi o rimuovi un articolo preferito
    func toggleFavoriteArticle(_ articleId: Int, token: String) async {
        do {
            let _: [FavoriteArticleResponse] = try await apiService.put(endpoint: "/users/me/favorites/articles", body: ["articleId": articleId], token: token)
            await loadFavoriteArticles(token: token)
        } catch {
            print("Errore toggle articolo preferito: \(error)")
        }
    }
}
