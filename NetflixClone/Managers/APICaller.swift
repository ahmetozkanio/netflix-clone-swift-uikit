//
//  APICaller.swift
//  NetflixClone
//
//  Created by Ahmet Özkan on 10.08.2023.
//

import Foundation

extension APICaller{
    struct Constants {
        static let API_KEY = "2faa2bdda699f241a1e3e8d7c9effaa1"
        static let baseURL = "https://api.themoviedb.org"
    }
}
enum APIError: Error {
    case failedToGetdata
}

final class APICaller {
    static let shared = APICaller()
    
    let jsonDecoder = JSONDecoder()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingMoviesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
