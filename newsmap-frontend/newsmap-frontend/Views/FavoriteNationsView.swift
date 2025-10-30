import SwiftUI

struct FavoriteNationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var showingDeleteAlert = false
    @State private var countryToDelete: Country?

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                List(user.favoriteCountries) { country in
                    HStack {
                        NavigationLink(destination: NewsListView(newsViewModel: NewsViewModel(), countryCode: country.isoCode, countryName: country.name)) {
                            Text(country.name)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    countryToDelete = country
                                    showingDeleteAlert = true
                                }
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
        .alert("Delete Favorite Country", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let country = countryToDelete {
                    Task {
                        let token = KeychainHelper.standard.read(service: "auth", account: "jwt")
                        await viewModel.removeFavoriteCountry(isoCode: country.isoCode, token: token)
                        await viewModel.getMyProfile()
                        countryToDelete = nil
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                countryToDelete = nil
            }
        } message: {
            Text("Are you sure you want to remove this country from your favorites?")
        }
        }
    }


struct FavoriteNationsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNationsView()
            .environmentObject(FavoritesViewModel())
    }
}
