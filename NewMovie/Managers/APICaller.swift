//
//  APICaller.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import Foundation
//struct Constants {
//    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
//    static let baseURL = "https://api.themoviedb.org"
//    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
//    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
//}
enum APIError: Error {
    case failedTogetData
}
class APICaller {
    static let shared = APICaller()
    
        func fetchAPI<T: Decodable>(url: URL) async throws -> T {
            try await withCheckedThrowingContinuation({ c in

            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data1, _, error in
                    guard data1 == data1, error == nil else {
                        return                    }
                    do {
                        let results = try JSONDecoder().decode(T.self, from: data1!)
                        c.resume(returning: results)
                    } catch {
                        c.resume(throwing: APIError.failedTogetData)
                    }
                }
                task.resume()
            })
        
    }
    func fetchAPIs<T: Decodable>(urls: [URL]) async throws -> [T] {
        try await withThrowingTaskGroup(of: T.self, body: { group in
            
            for url in urls {
                group.addTask {
                    try await self.fetchAPI(url: url)
                }
            }
            
            var results = [T]()
            for try await result in group {
                results.append(result)
            }
            return results
        })
    }
    
}

