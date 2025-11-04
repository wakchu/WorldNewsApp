
import SwiftUI

struct AppHeaderView: View {
    @Binding var selectedTab: Int
    @Binding var showingSettings: Bool

    var body: some View {
        HStack {
            Text("WorldNewsApp")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)

            Spacer()

            Button(action: {
                showingSettings = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .padding(.trailing)
            }
        }
        .padding(.vertical, 8)
        .background(Color.clear)
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { 
            AppHeaderView(selectedTab: .constant(0), showingSettings: .constant(false))
        }
    }
}
