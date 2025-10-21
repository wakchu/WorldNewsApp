import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationStack {
            TabView {
                FavoriteNationsView()
                    .tabItem {
                        Label("Nations", systemImage: "flag.fill")
                    }
                
                FavoriteNewsView()
                    .tabItem {
                        Label("News", systemImage: "newspaper.fill")
                    }
            }
            .navigationBarHidden(true)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}