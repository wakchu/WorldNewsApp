
import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        HStack {
            Text("WorldNewsApp")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)

            Spacer()

            Menu {
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
                NavigationLink(destination: FavoriteNewsView()) {
                    Label("Favorite News", systemImage: "newspaper")
                }
                NavigationLink(destination: FavoriteNationsView()) {
                    Label("Favorite Nations", systemImage: "flag.fill")
                }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                    .padding(.trailing)
            }
        }
        .padding(.vertical, 8)
        .background(Color.clear) // Or a specific color if desired
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { // Wrap in NavigationStack for NavigationLink to work in preview
            AppHeaderView()
        }
    }
}
