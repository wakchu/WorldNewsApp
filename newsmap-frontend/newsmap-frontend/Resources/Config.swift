import Foundation

class Config {
    static let shared = Config()
    
    let baseURL: String
    
    private init() {
        guard
            let url = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: url),
            let baseURL = dict["API_BASE_URL"] as? String
        else {
            fatalError("API_BASE_URL non trovato in Config.plist")
        }
        
        self.baseURL = baseURL
    }
}
