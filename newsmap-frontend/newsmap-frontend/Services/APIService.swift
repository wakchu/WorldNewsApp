import Foundation

class APIService {
    
    let baseURL = Config.shared.baseURL

    
    // MARK: - Generic GET
    func get<T: Decodable>(endpoint: String, queryItems: [URLQueryItem]? = nil, token: String? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Generic POST
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U, token: String? = nil) async throws -> T {
        print("APIService: post called for endpoint: \(endpoint)")
        print("APIService: baseURL is: \(baseURL)")
        guard let url = URL(string: baseURL + endpoint) else {
            print("APIService: Error - Bad URL for endpoint: \(baseURL + endpoint)")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)
        
        print("APIService: Making network request to: \(url.absoluteString)")
        let (data, response) = try await URLSession.shared.data(for: request)
        print("APIService: Network request completed.")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("APIService: HTTP Status Code: \(httpResponse.statusCode)")
        }

        do {
            try validateResponse(response)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            print("APIService: Data decoded successfully.")
            return decodedData
        } catch {
            print("APIService: Error during post or decoding: \(error.localizedDescription)")
            throw error
        }
    }

    func postEmpty<U: Encodable>(endpoint: String, body: U, token: String? = nil) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }

    func postEmpty(endpoint: String, token: String? = nil) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }
    
    // MARK: - Generic PUT
    func put<T: Decodable, U: Encodable>(endpoint: String, body: U, token: String? = nil) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Generic DELETE
    func delete(endpoint: String, token: String? = nil) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
    }
    
    // MARK: - Response validation
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
        }
    }
}
