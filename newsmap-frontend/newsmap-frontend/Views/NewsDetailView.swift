import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticleResponse
    @State private var isBookmarked: Bool = false
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel // Use FavoritesViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let imageUrl = article.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) {
                        image in image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(article.sourceName)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(article.publishedAt)
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(article.description ?? "")
                    .font(.body)

                if let articleUrl = URL(string: article.url) {
                    Link("Read full article", destination: articleUrl)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("News Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Check if the news is already bookmarked when the view appears
            if let user = favoritesViewModel.user {
                isBookmarked = user.favoriteNews.contains(where: { $0.id == article.id })
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        let token = KeychainHelper.standard.read(service: "auth", account: "jwt")
                        do {
                            if isBookmarked {
                                // If already bookmarked, remove it
                                try await favoritesViewModel.removeFavoriteNews(newsId: article.id, token: token)
                                isBookmarked = false
                                print("News unbookmarked successfully!")
                            } else {
                                // If not bookmarked, add it
                                try await favoritesViewModel.addFavoriteNews(newsId: article.id, token: token)
                                isBookmarked = true
                                print("News bookmarked successfully!")
                            }
                        } catch {
                            print("Error bookmarking/unbookmarking news: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Image(systemName: isBookmarked ? "heart.fill" : "heart")
                        .foregroundColor(isBookmarked ? .red : .gray)
                }
            }
        }
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewsDetailView(article: NewsArticleResponse(
                id: 1,
                title: "Sample News Title",
                description: "This is a sample description for a news article. It provides more details about the event.",
                url: "https://example.com",
                imageUrl: "https://via.placeholder.com/300",
                publishedAt: "2023-10-27 10:00:00",
                source: SourceResponse(id: 1, name: "Sample Source", url: "https://example.com")
            ))
        }
    }
}
