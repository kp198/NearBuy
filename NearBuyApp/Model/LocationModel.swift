//
//  LocationModel.swift
//  NearBuyApp
//
//  Created by G Keerthika Priya on 17/03/24.
//

import Foundation
class LocationList {
    weak var presenter: Presenter?
    var latitude: String?
    var longitude: String?
    var totalLocations: Int = 0
    var distance: String = "1"
    
    var locations: [LocationModel]? {
        didSet {
            if let locations = locations, let locationEncodedData = try? JSONEncoder().encode(locations) {
                UserDefaults.standard.set(locationEncodedData, forKey: "locationList")
            }
            self.presenter?.reloadLocationTable()
        }
    }
    
    init() {
        if let locations = UserDefaults.standard.data(forKey: "locationList"), let locationLsist = try? JSONDecoder().decode([LocationModel].self, from: locations) {
            self.locations = locationLsist
        }
    }
    
}

struct Venues: Codable {
    var venues: [LocationModel]?
    var meta: Meta
}

struct Meta: Codable {
    var total: Int
    var per_page: Int
    var page: Int
    var geolocation: Geolocation
}

struct Geolocation: Codable {
    var lat: Float?
    var lon: Float?
}

struct LocationModel: Codable {
    var name: String?
    var address: String?
    var url: String?
}
