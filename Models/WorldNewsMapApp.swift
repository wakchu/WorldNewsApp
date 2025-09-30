import SwiftUI

@main
struct WorldNewsMapApp: App {

    // Services
    private let apiService = APIService()
    private let authService = AuthService()
    private let newsService = NewsService()
    private let countryService = CountryService()

    // ViewModels
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var mapVM = MapViewModel()
    @StateObject private var newsVM = NewsViewModel()
    @StateObject private var favoritesVM = FavoritesViewModel()

    init() {
        _authVM = StateObject(wrappedValue: AuthViewModel(authService: authService))
        _mapVM = StateObject(wrappedValue: MapViewModel(countryService: countryService))
        _newsVM = StateObject(wrappedValue: NewsViewModel(newsService: newsService))
        _favoritesVM = StateObject(wrappedValue: FavoritesViewModel())
        _ = apiService // placeholder per evitare warning di variabile inutilizzata
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
                .environmentObject(mapVM)
                .environmentObject(newsVM)
                .environmentObject(favoritesVM)
        }
    }
}

private struct RootView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var mapVM: MapViewModel
    @EnvironmentObject private var newsVM: NewsViewModel

    var body: some View {
        Group {
            if authVM.isAuthenticated {
                TabView {
                    NavigationStack {
                        MapView()
                    }
                    .tabItem {
                        Label("Mappa", systemImage: "map")
                    }

                    NavigationStack {
                        NewsListView()
                    }
                    .tabItem {
                        Label("Notizie", systemImage: "newspaper")
                    }

                    NavigationStack {
                        FavoritesView()
                    }
                    .tabItem {
                        Label("Preferiti", systemImage: "star")
                    }
                }
                .onAppear {
                    if mapVM.countries.isEmpty {
                        mapVM.loadCountries()
                    }
                }
            } else {
                NavigationStack {
                    LoginView()
                }
            }
        }
        .task(id: mapVM.selectedCountry?.code) {
            if let country = mapVM.selectedCountry {
                await newsVM.loadTopHeadlines(for: country)
            }
        }
    }
}
