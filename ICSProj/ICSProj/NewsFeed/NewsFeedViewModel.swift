//
//  NewsFeedViewModel.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import Foundation

class NewsFeedViewModel {
    private let newsFeedService: NewsFeedServiceProtocol
    
    init(newsFeedService: NewsFeedServiceProtocol = NewsFeedService()){
        self.newsFeedService = newsFeedService
    }
    
    func getArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        newsFeedService.getNewsFeed { result in
            switch result {
            case .success(let newsFeed):
                completion(.success(newsFeed?.articles ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
