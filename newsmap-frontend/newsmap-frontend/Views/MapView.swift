import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                Text("Hello World")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarHidden(true) // Hide the default navigation bar
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
