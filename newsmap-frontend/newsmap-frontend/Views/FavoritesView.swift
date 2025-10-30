import SwiftUI

struct FavoritesView: View {
    @State private var selectedView: String = "Nations"
    let viewOptions = ["Nations", "News"]

    var body: some View {
        VStack {
            Picker("Select View", selection: $selectedView) {
                ForEach(viewOptions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if selectedView == "Nations" {
                FavoriteNationsView()
            } else {
                FavoriteNewsView()
            }
        }
        .navigationTitle("Favorites")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoritesView()
                .environmentObject(FavoritesViewModel())
        }
    }
}