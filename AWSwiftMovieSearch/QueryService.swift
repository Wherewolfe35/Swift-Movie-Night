//
//  QueryService.swift
//  AWSwiftMovieSearch
//
//  Created by Aaron Wolfe on 4/7/20.
//  Copyright © 2020 Aaron Wolfe. All rights reserved.
//

import Foundation
import Foundation.NSURL

// JSON object
class Movie {

    let title: String
    let overview: String
    let releaseDate: String
    let backdropPath: String
    let index: Int
    
    init(title: String, overview: String, releaseDate: String, backdropPath: String, index: Int) {
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.index = index
    }
}


class QueryService {
    
    let defaultSession = URLSession(configuration: .default)
    let apiKey:String = "2696829a81b1b5827d515ff121700838"
    
    var dataTask: URLSessionDataTask?
    var movies: [Movie] = []
    var errorMessage = ""
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Movie]?, String) -> Void
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult){
        print("Searching database for \(searchTerm)")
        
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/search") {
            urlComponents.query = "/movie?api_key=\(apiKey)&query=\(searchTerm)&page=1"
        
        guard let url = urlComponents.url else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) {
            [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
        if let error = error {
            self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if
            let data = data,
            let response = response as? HTTPURLResponse, response.statusCode == 200 {
            self?.updateSearchResults(data)
        
        
        DispatchQueue.main.async {
            completion(self?.movies, self?.errorMessage ?? "" )
          }
        }
      }
            dataTask?.resume()
    }
  }
    
    private func updateSearchResults(_ data: Data) {
      var response: JSONDictionary?
      movies.removeAll()
      
      do {
        response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
      } catch let parseError as NSError {
        errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
        return
      }
      
      guard let array = response!["results"] as? [Any] else {
        errorMessage += "Dictionary does not contain results key\n"
        return
      }
      
      var index = 0
      
      for movieDictionary in array {
        if let movieDictionary = movieDictionary as? JSONDictionary,
          let releaseDate = movieDictionary["releaseDate"] as? String,
          let backdropPath = movieDictionary["backdropPath"] as? String,
          let title = movieDictionary["title"] as? String,
          let overview = movieDictionary["overview"] as? String {
            movies.append(Movie(title: title, overview: overview, releaseDate: releaseDate, backdropPath: backdropPath, index: index))
            index += 1
        } else {
          errorMessage += "Problem parsing trackDictionary\n"
        }
      }
    }
}

