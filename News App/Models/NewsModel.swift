//
//  NewsModel.swift
//  News App
//
//  Created by PremierSoft on 16/07/21.
//

import Foundation

struct Article: Codable {
    var source: Source
    var author: String?
    var title: String
    var articleDescription: String?
    var url: String
    var urlToImage: String?
    var publishedAt: Date
    var content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

struct Source: Codable {
    var id: String?
    var name: String
}

struct NewsInformation: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]

    enum CodingKeys: String, CodingKey {
        case status, totalResults, articles
    }
}
