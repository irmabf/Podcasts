//
//  APIService.swift
//  Podcasts
//
//  Created by Irma Blanco on 24/04/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
     let baseiTunesSearch = "https://itunes.apple.com/search"
    //singleton
    static let shared = APIService()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
       
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(baseiTunesSearch, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact yahoo", err)
                return
            }
            guard let data = dataResponse.data else { return }
            
            do {
                let searchResult =  try
                    JSONDecoder().decode(SearchResults.self,from: data)
                    print(searchResult.resultCount)
                    completionHandler(searchResult.results)
                
                print(searchResult.resultCount)
//                self.podcasts = searchResult.results
//                self.tableView.reloadData()
            }catch let decodeErr {
                print("Failed to decode:",decodeErr)
            }
        }
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}
