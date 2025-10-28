import SwiftUI

struct FavoriteNewsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: FavoritesViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                List(user.favoriteNews) { news in
                    NavigationLink(destination: NewsDetailView(article: news.toNewsArticleResponse())) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(news.title)
                                    .font(.headline)
                                Text(news.description?.prefix(100).appending("...") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                Task {
                                    await viewModel.removeFavoriteNews(newsId: news.id)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            } else {
                Text("No favorite news found.")
            }
        }
        .onAppear {
            Task {
                await viewModel.getMyProfile()
            }
        }
        .navigationTitle("Favorite News")
    }
};struct FavoriteNewsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNewsView()
            .environmentObject(FavoritesViewModel())
    }
}
