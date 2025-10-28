import SwiftUI

struct NewsListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var newsViewModel: NewsViewModel
    let countryCode: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            Text("News from \(countryCode)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            if newsViewModel.isLoading {
                ProgressView()
                Spacer()
            } else if newsViewModel.articles.isEmpty {
                Text("Non ci sono notizie disponibili per \(countryCode)")
                    .font(.headline)
                    .padding()
                Spacer()
            } else {
                List(newsViewModel.articles, id: \.id) { article in
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.description ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(newsViewModel: NewsViewModel(), countryCode: "us")
    }
}
