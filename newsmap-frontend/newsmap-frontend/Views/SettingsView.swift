import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                Text("Hello World - Settings")
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}