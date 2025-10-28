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
    @StateObject private var mapVM = MapViewModel(countryService: CountryService())
    @StateObject private var newsVM = NewsViewModel(newsService: NewsService())
    @StateObject private var favoritesVM = FavoritesViewModel()
    
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
    @State private var selectedTab: Int = 0 // 0 for Map, 1 for Favorites
    @State private var showingSettings: Bool = false
    
    var body: some View {
        Group {
            if authVM.isLoggedIn {
                VStack(spacing: 0) {
                    AppHeaderView(selectedTab: $selectedTab, showingSettings: $showingSettings)
                    TabView(selection: $selectedTab) {
                        NavigationStack {
                            MapView()
                        }
                        .tag(0)
                        .tabItem {
                            Label("Map", systemImage: "map")
                        }
                        

                        
                        NavigationStack {
                            FavoritesView()
                        }
                        .tag(1)
                        .tabItem {
                            Label("Favorites", systemImage: "star")
                        }
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    NavigationStack {
                        SettingsView()
                    }
                }
                .task {
                    if mapVM.countries.isEmpty {
                        await mapVM.loadCountries()
                    }
                }
            } else {
                NavigationStack {
                    LoginView()
                }
            }
        }
        .id(authVM.isLoggedIn) // Add this line
        .task(id: mapVM.selectedCountry?.code) {
            if let countryResponse = mapVM.selectedCountry {
                let token = KeychainHelper.standard.read(service: "auth", account: "jwt")
                await newsVM.loadNews(for: countryResponse.code, token: token)
            }
        }
    }
}
