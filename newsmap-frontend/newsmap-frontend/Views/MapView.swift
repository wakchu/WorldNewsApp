import SwiftUI

struct MapView: View {
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
