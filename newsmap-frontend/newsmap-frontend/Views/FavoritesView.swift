import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack {
            Text("Hello World")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
