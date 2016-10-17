//
//  Movie.swift
//  Flicks
//
//  Created by Kevin Balvantkumar Patel on 10/16/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//
// Sample Data
//{
//    poster_path: "/z6BP8yLwck8mN9dtdYKkZ4XGa3D.jpg",
//    adult: false,
//    overview: "A big screen remake of John Sturges' classic western The Magnificent Seven, itself a remake of Akira Kurosawa's Seven Samurai. Seven gun men in the old west gradually come together to help a poor village against savage thieves.",
//    release_date: "2016-09-14",
//    genre_ids: [
//    28,
//    12,
//    37
//    ],
//    id: 333484,
//    original_title: "The Magnificent Seven",
//    original_language: "en",
//    title: "The Magnificent Seven",
//    backdrop_path: "/T3LrH6bnV74llVbFpQsCBrGaU9.jpg",
//    popularity: 27.313045,
//    vote_count: 558,
//    video: false,
//    vote_average: 4.54
//},

import Foundation

class Movie {
    
    let title: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    
    init(withDictionary movieDictionary:[String: Any]) {
        self.title = movieDictionary["title"] as? String
        self.overview = movieDictionary["overview"] as? String
        self.backdrop_path = movieDictionary["backdrop_path"] as? String
        self.poster_path = movieDictionary["poster_path"] as? String
    }
    
    static func moviesFrom(array: [[String: Any]] ) -> [Movie] {
        var results = [Movie]()
        
        for dictionary in array {
            results.append(Movie(withDictionary: dictionary))
        }
        
        return results
    }
}
