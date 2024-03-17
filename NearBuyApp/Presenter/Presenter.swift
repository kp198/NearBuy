//
//  Presenter.swift
//  NearBuyApp
//
//  Created by G Keerthika Priya on 17/03/24.
//

import Foundation

class Presenter {
    var locationsList = LocationList()
    let networkLayer = NetworkLayer()
    weak var locationViewDelegate: LocationViewDelegate?
    
    init() {
        locationsList.presenter = self
    }
    
    func fetchLocationsFromServer(page: String, lat: String? = nil, long: String? = nil) {
        self.locationsList.latitude = (lat != nil) ? lat : self.locationsList.latitude
        self.locationsList.longitude = (long != nil) ? long : self.locationsList.longitude
        networkLayer.fetchLocationsFromServer(lat: lat ?? self.locationsList.latitude ?? "0", long: long ?? self.locationsList.longitude ?? "0", page: page, distance: self.locationsList.distance,completion: {[weak self]
            venues, meta in
            if page == "1" {
                self?.locationsList.locations = []
            }
            self?.locationsList.locations?.append(contentsOf: venues ?? [])
            let locations = self?.locationsList.locations
            self?.locationsList.locations = locations
            self?.locationsList.totalLocations = meta.total
            if meta.geolocation.latitude !=  nil && meta.geolocation.longitude != nil {
                self?.locationsList.latitude = meta.geolocation.latitude
                self?.locationsList.longitude = meta.geolocation.longitude
            }
        })
    }
    
    func getLocations() -> [LocationModel]? {
        return locationsList.locations
    }
    
    func getLocationAtIndex(index: Int) -> LocationModel? {
        
        checkForPagination(index: index)
        if locationsList.locations?.count ?? 0 > index {
            return locationsList.locations?[index]
        }
        return nil
    }
    
    func checkForPagination(index: Int) {
        let totalItems = locationsList.totalLocations
        if let location = locationsList.locations, index == location.count - 1, location.count < totalItems {
            let page = "\((index+1)/10+1)" // 10 items per fetch
            print(page)
            self.fetchLocationsFromServer(page: page)
        }
    }
    
    func reloadLocationTable() {
        self.locationViewDelegate?.reloadLocationTable()
    }
    
    func setDistance(distance: String) {
        self.locationsList.distance = distance
        fetchLocationsFromServer(page: "1")
    }
}
