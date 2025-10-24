import SwiftUI
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticleResponse] = []
    private let newsService: NewsService
    
    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }
    

    func loadNews(for isoCode: String) async {
        do {
            let result = try await newsService.getNews(for: isoCode)
            self.articles = result
        } catch {
            print("Errore caricamento notizie: \(error)")
            self.articles = []
        }
    }
}
