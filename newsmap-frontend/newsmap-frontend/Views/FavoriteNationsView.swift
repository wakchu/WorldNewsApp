import SwiftUI

struct FavoriteNationsView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let user = viewModel.user {
                    List(user.favoriteCountries) { country in
                        HStack {
                            Text(country.name)
                            Spacer()
                            Button(action: {
                                Task {
                                    await viewModel.removeFavoriteCountry(isoCode: country.isoCode)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                } else {
                    Text("No favorite countries found.")
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

struct FavoriteNationsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNationsView()
    }
}
