import SwiftUI
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticleResponse] = []
    @Published var isLoading: Bool = false
    private let newsService: NewsService
    
    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }
    

    func loadNews(for isoCode: String, token: String?) async {
        print("NewsViewModel: Loading news for country: \(isoCode)")
        isLoading = true
        do {
            let result = try await newsService.getNews(for: isoCode, token: token)
            print("NewsViewModel: Received \(result.count) articles from service.")
            self.articles = Array(result.prefix(10))
            print("NewsViewModel: articles count after update: \(self.articles.count)")
        } catch {
            print("Errore caricamento notizie: \(error)")
            self.articles = []
        }
        isLoading = false
    }
}
