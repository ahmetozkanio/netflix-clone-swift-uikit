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

final class APICaller {
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (String) -> () ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
