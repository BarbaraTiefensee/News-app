//
//  Network.swift
//  News App
//
//  Created by PremierSoft on 15/07/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let session = URLSession.shared
    
    func getApiKey() -> String? {
        if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let value = NSDictionary(contentsOfFile: filePath)?.object(forKey: "URL_API_KEY") as? String {
            
            return value
        }
        else {
            return nil
        }
    }
    
    func fetch<T>(_:T.Type, endpoint: Endpoint, completion: @escaping(Result<T, Error>) -> Void) where T: Decodable {
        
        guard let apiKey = getApiKey() else {
            let error = NSError(domain: "Não foi possível acessar a API", code: 001, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let urlEndPoint = CreateURL.urlQuery(endpoint: endpoint, apiKey: apiKey)
        
        guard let url = urlEndPoint.url else {
            let error = NSError(domain: "Error", code: 001, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 60)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    let error = NSError(domain: "Error", code: 001, userInfo: nil)
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.defaultDate)
                let decoderNews = try decoder.decode(T.self, from: data)
                completion(.success(decoderNews))
            } catch {
                completion(.failure(error))
            }
        })
        task.resume()
    }
}

