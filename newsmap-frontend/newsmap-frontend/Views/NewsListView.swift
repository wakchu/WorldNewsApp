import SwiftUI

struct NewsListView: View {
    let countryName: String
    let isoCode: String
    
    @StateObject private var viewModel = NewsViewModel()
    
    var body: some View {
        VStack {
            AppHeaderView()
            Text("News from \(countryName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            List(viewModel.articles, id: \.id) { article in
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.headline)
                    Text(article.description ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadNews(for: isoCode)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(countryName: "United States", isoCode: "us")
    }
}