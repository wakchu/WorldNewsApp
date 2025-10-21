import SwiftUI

struct FavoriteNationsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                Text("Hello World - Favorite Nations")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

struct FavoriteNationsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNationsView()
    }
}