//
//  QueryService.swift
//  AWMovieNight
//
//  Created by Aaron Wolfe on 4/2/20.
//  Copyright © 2020 Aaron Wolfe. All rights reserved.
//

import Foundation
import Foundation.NSURL


class Movie {
    // Fill out Movie JSON decoding
    
}


class QueryService {
    
    let defaultSession = URLSession(configuration: .default)
    let apiKey:String = "2696829a81b1b5827d515ff121700838"
    
    var dataTask: URLSessionDataTask?
    var movies = [Movie] = []
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Movie]?, String) -> Void
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult){
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/search") {
            urlComponents.query = "movie?api_key=\(apiKey)&query=\(searchTerm)"
        }
    }
}
