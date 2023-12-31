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
        static let YouTubeAPI_KEY = "AIzaSyAV3vGGogmsOHK_sR9S6y9Xh_ZBAwgxK2w"
        static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search"
    }
}
enum APIError: Error {
    case failedToGetdata
}

final class APICaller {
    static let shared = APICaller()
    
    let jsonDecoder = JSONDecoder()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void )  {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void )  {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void )  {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void )  {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void )  {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void )  {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query))") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void )  {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)?key=\(Constants.YouTubeAPI_KEY)&q=\(query))") else { return }


        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard
                let data = data,
                error == nil
            else {
                return
            }
            
            do {
                let result = try self.jsonDecoder.decode(YoutubeSearchResults.self, from: data)
                guard let item = result.items?[0] else {
                    completion(.failure(APIError.failedToGetdata))
                    return
                }
                completion(.success(item))

                
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
}
