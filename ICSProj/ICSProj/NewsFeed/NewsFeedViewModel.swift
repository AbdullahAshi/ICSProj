//
//  NewsFeedViewModel.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import Foundation

class NewsFeedViewModel {
    private let service = NewsFeedService()
    
    func getArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        service.getNewsFeed { result in
            switch result {
            case .success(let newsFeed):
                completion(.success(newsFeed?.articles ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
