//
//  NetworkingClass.swift
//  Fundall Test
//
//  Created by chukwuma.udokporo on 15/06/2021.
//

import Foundation


import UIKit

class Networking {
    
    /*:
     Created a static variable instanciating the MovieList class
     So i don't created instaces whenever i need to call the MovieList
     */
    static let shared = Networking()
    
    private let baseURL = "https://campaign.fundall.io"
 
    
    
    //Register user
    //Post request to register a user with User model @Model
    func registerUser(completion: @escaping([Movie]) -> ()) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(baseURL)")! as URL)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else {
                print("Network error: \(error!.localizedDescription)")
                return
            }
            
            
            guard let movies = try? JSONDecoder().decode(MoviesData.self, from: data) else {
                print("Couldn't decode json")
                return
            }
            completion(movies.movies)
        }
        dataTask.resume()
    }

    
}




struct MoviesData: Codable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

//Movie Model
struct Movie: Codable {
    
    let title: String?
    let year: String?
    let rate: Double?
    let posterImage: String?
    var overview: String?
    
    // Set default Movie parameters for movie model
    private enum CodingKeys: String, CodingKey {
        case title, overview
        case year = "release_date"
        case rate = "vote_average"
        case posterImage = "poster_path"
    }
}

