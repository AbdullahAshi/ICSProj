//
//  NewsFeed.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import Foundation

// MARK: - NewsFeed
struct NewsFeed: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(Source.self, forKey: .source)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        content = try container.decode(String.self, forKey: .content)
        let publishedAtString = try container.decode(String.self, forKey: .publishedAt)
        if let date = ISO8601DateFormatter().date(from: publishedAtString) {
            publishedAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .publishedAt, in: container, debugDescription: "Date string does not match ISO8601 format")
        }
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
