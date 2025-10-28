import SwiftUI

struct NewsListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var newsViewModel: NewsViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    let countryCode: String
    let countryName: String
    @State private var isCountryFavorite: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            HStack {
                Text("News from \(countryName)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button(action: {
                    Task {
                        print("NewsListView: Heart button tapped.")
                        let token = KeychainHelper.standard.read(service: "auth", account: "jwt")
                        if isCountryFavorite {
                            print("NewsListView: Attempting to remove favorite country: \(countryCode)")
                            await favoritesViewModel.removeFavoriteCountry(isoCode: countryCode, token: token)
                        } else {
                            print("NewsListView: Attempting to add favorite country: \(countryCode)")
                            await favoritesViewModel.addFavoriteCountry(isoCode: countryCode, token: token)
                        }
                    }
                }) {
                    Image(systemName: isCountryFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isCountryFavorite ? .red : .gray)
                }
            }
            .padding()
            
            if newsViewModel.isLoading {
                ProgressView()
                Spacer()
            } else if newsViewModel.articles.isEmpty {
                Text("Non ci sono notizie disponibili per \(countryName)")
                    .font(.headline)
                    .padding()
                Spacer()
            } else {
                List(newsViewModel.articles, id: \.id) { article in
                    NavigationLink(destination: NewsDetailView(article: article).environmentObject(newsViewModel)) {
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.description?.prefix(100).appending("...") ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .onAppear {
            print("NewsListView: onAppear - Checking favorite status for \(countryCode)")
            if let user = favoritesViewModel.user {
                isCountryFavorite = user.favoriteCountries.contains(where: { $0.isoCode == countryCode })
                print("NewsListView: onAppear - isCountryFavorite: \(isCountryFavorite)")
            }
            Task {
                let token = KeychainHelper.standard.read(service: "auth", account: "jwt")
                await newsViewModel.loadNews(for: countryCode, token: token)
            }
        }
        .onChange(of: favoritesViewModel.user) { newUser in
            print("NewsListView: favoritesViewModel.user changed.")
            if let user = newUser {
                let newFavoriteStatus = user.favoriteCountries.contains(where: { $0.isoCode == countryCode })
                if newFavoriteStatus != isCountryFavorite {
                    isCountryFavorite = newFavoriteStatus
                    print("NewsListView: isCountryFavorite updated to: \(isCountryFavorite)")
                }
            } else {
                if isCountryFavorite != false {
                    isCountryFavorite = false
                    print("NewsListView: isCountryFavorite updated to: false (user is nil)")
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(newsViewModel: NewsViewModel(), countryCode: "us", countryName: "United States")
            .environmentObject(FavoritesViewModel())
    }
}
