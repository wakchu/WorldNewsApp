import SwiftUI

struct FavoriteNationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: FavoritesViewModel

    var body: some View {
        VStack {
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
        .navigationTitle("Favorite Nations")
    }
}

struct FavoriteNationsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNationsView()
            .environmentObject(FavoritesViewModel())
    }
}
