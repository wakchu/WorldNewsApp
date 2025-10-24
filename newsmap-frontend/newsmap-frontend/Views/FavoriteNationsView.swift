import SwiftUI

struct FavoriteNationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                    .padding()
                    Spacer()
                }
                
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
