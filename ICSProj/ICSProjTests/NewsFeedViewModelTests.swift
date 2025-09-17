//
//  MockNewsFeedsService.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import XCTest
@testable import ICSProj

class NewsFeedViewModelTests: XCTestCase {
    func testGetArticlesSuccess() {
        let mockService = MockNewsFeedService()
        let articles = [Article(source: Source(id: "123", name: "Source"), author: "Author", title: "Test Title", description: "Desc", url: "http://example.com", urlToImage: nil, publishedAt: Date(), content: "Content")]
        let newsFeed = NewsFeed(status: "ok", totalResults: 1, articles: articles)
        mockService.mockNewsFeed = newsFeed
        let viewModel = NewsFeedViewModel(newsFeedService: mockService)
        let expectation = self.expectation(description: "Articles fetched")
        viewModel.getArticles { result in
            switch result {
            case .success(let articles):
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, "Test Title")
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testGetArticlesEmpty() {
        let mockService = MockNewsFeedService()
        let newsFeed = NewsFeed(status: "ok", totalResults: 0, articles: [])
        mockService.mockNewsFeed = newsFeed
        let viewModel = NewsFeedViewModel(newsFeedService: mockService)
        let expectation = self.expectation(description: "No articles")
        viewModel.getArticles { result in
            switch result {
            case .success(let articles):
                XCTAssertTrue(articles.isEmpty)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testGetArticlesFailure() {
        let mockService = MockNewsFeedService()
        mockService.mockError = NSError(domain: "Test", code: 1, userInfo: nil)
        let viewModel = NewsFeedViewModel(newsFeedService: mockService)
        let expectation = self.expectation(description: "Error case")
        viewModel.getArticles { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure:
                XCTAssertTrue(true) // Success: error was returned
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
