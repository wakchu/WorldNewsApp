import SwiftUI

struct FavoriteNewsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var showingDeleteAlert = false
    @State private var newsToDelete: News?

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                List(user.favoriteNews) { news in
                    HStack {
                        NavigationLink(destination: NewsDetailView(article: news.toNewsArticleResponse())) {
                            VStack(alignment: .leading) {
                                Text(news.title)
                                    .font(.headline)
                                Text(news.description?.prefix(100).appending("...") ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    newsToDelete = news
                                    showingDeleteAlert = true
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
        .alert("Delete Favorite News", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let news = newsToDelete {
                    Task {
                        let token = KeychainHelper.standard.read(service: "auth", account: "jwt")
                        await viewModel.removeFavoriteNews(newsId: news.id, token: token)
                        await viewModel.getMyProfile()
                        newsToDelete = nil
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                newsToDelete = nil
            }
        } message: {
            Text("Are you sure you want to remove this news from your favorites?")
        }
    }
};struct FavoriteNewsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNewsView()
            .environmentObject(FavoritesViewModel())
    }
}
