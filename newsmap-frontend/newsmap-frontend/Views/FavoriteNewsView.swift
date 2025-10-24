import SwiftUI

struct FavoriteNewsView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let user = viewModel.user {
                    List(user.favoriteNews) { news in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(news.title)
                                    .font(.headline)
                                Text(news.description ?? "")
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
                } else {
                    Text("No favorite news found.")
                }
            }
            .onAppear {
                Task {
                    await viewModel.getMyProfile()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct FavoriteNewsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNewsView()
    }
}
