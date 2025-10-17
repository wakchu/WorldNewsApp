import SwiftUI
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticleResponse] = []
    private let newsService: NewsService
    
    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }
    
    func loadTopHeadlines(for country: Country) async {
        do {
            let result = try await newsService.getTopHeadlines(for: country.code)
            self.articles = result
        } catch {
            print("Errore caricamento notizie: \(error)")
            self.articles = []
        }
    }
}
