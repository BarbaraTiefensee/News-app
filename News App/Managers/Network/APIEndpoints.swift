//
//  APIEndpoints.swift
//  News App
//
//  Created by PremierSoft on 19/07/21.
//

import Foundation

enum Endpoint: String {
    case everything = "/v2/everything"
    case topHeadlines = "/v2/top-headlines"
    case topHeadlinesSource = "v2/top-headlines/sources"
}

struct CreateURL {
    let path: String
    let queryItems: [URLQueryItem]
    
    static let countriesAvaliable = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hj", "hu", "id", "ie", "il", "in", "it",
                   "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw",
                   "ua", "us", "ve", "za"]
    
    static var localeCountry: String? {
        let locale = Locale.current
        let localeCode = locale.regionCode?.lowercased()
        
        guard let local = localeCode else { return "us" }
        if countriesAvaliable.contains(local) {
            return local
        } else {
            return "us"
        }
    }
    
    static func urlQuery(endpoint: Endpoint, apiKey: String?) -> CreateURL {
        return CreateURL(
            path: endpoint.rawValue,
            queryItems: [
                URLQueryItem(name: "country", value: localeCountry),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
        )
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
