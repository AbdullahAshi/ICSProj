//
//  NewsFeedService.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import Foundation

protocol NewsFeedServiceProtocol {
    func getNewsFeed(completion: @escaping (Result<NewsFeed?, Error>) -> Void) -> URLSessionDataTaskProtocol?
}

class NewsFeedService: NewsFeedServiceProtocol  {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    private let newsFeedURLString = "https://newsapi.org/v2/everything?q=tesla&from=2025-08-17&sortBy=publishedAt&apiKey=24dc5be9d97c448eacbdd459e3fe3469"
    
    @discardableResult
    func getNewsFeed(completion: @escaping (Result<NewsFeed?, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        guard let url = URL(string: newsFeedURLString) else {
            completion(.failure(NetworkError.invalidResponse("Invalid URL")))
            return nil
        }
        return networkService.get(url: url, completion: completion)
    }
}
