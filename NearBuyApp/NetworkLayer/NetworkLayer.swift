//
//  NetworkLayer.swift
//  NearBuyApp
//
//  Created by G Keerthika Priya on 17/03/24.
//

import Foundation

class NetworkLayer {
    func fetchLocationsFromServer(lat: String, long: String, page: String = "1", distance: String = "1",completion: @escaping([LocationModel]?,Meta)->Void){
        var urlComp = URLComponents(string: "https://api.seatgeek.com/2/venues")
        urlComp?.queryItems = [URLQueryItem(name: "per_page", value: "10"),URLQueryItem(name: "page", value: page),URLQueryItem(name: "client_id", value: "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5"),URLQueryItem(name: "lat", value: lat),URLQueryItem(name: "lon", value: long), URLQueryItem(name: "range", value: distance+"mi")]
        if let url = urlComp?.url {
            URLSession.shared.dataTask(with:URLRequest(url: url) , completionHandler: {
                data, resp, error in
                if let data = data,let decodedData = try? JSONDecoder().decode(Venues.self, from: data) {
                    completion(decodedData.venues, decodedData.meta)
                }
            }).resume()
        }
    }
}
