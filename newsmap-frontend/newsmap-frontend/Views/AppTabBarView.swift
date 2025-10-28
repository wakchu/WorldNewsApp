import SwiftUI

struct AppTabBarView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var mapVM: MapViewModel
    @EnvironmentObject private var newsVM: NewsViewModel
    @EnvironmentObject private var favoritesVM: FavoritesViewModel

    var body: some View {
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
                Label("Favorites", systemImage: "heart")
            }
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView(selectedTab: .constant(0))
            .environmentObject(AuthViewModel())
            .environmentObject(MapViewModel(countryService: CountryService()))
            .environmentObject(NewsViewModel(newsService: NewsService()))
            .environmentObject(FavoritesViewModel())
    }
}
