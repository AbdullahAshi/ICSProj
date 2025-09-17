//
//  MockNewsFeedsService.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import Foundation
@testable import ICSProj

class MockNewsFeedService: NewsFeedServiceProtocol {
    var mockNewsFeed: ICSProj.NewsFeed?
    var mockError: Error?

    func getNewsFeed(completion: @escaping (Result<ICSProj.NewsFeed?, any Error>) -> Void) -> (any ICSProj.URLSessionDataTaskProtocol)? {
        if let error = mockError {
            completion(.failure(error))
        } else if let newsFeed = mockNewsFeed {
            completion(.success(newsFeed))
        }
        return nil
    }
}
