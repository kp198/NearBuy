//
//  LocationsVC.swift
//  NearBuyApp
//
//  Created by G Keerthika Priya on 17/03/24.
//

import UIKit
import CoreLocation

class LocationsVC: UIViewController, CLLocationManagerDelegate {

    let loader = UIActivityIndicatorView()
    let presenter = Presenter()
    let tableView = UITableView()
    let slider = UISlider()
    let sliderValue = UILabel()
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.locationViewDelegate = self
        checkForLocationPermissions()
        self.view.backgroundColor = .white
        self.view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor), loader.widthAnchor.constraint(equalToConstant: 20), loader.heightAnchor.constraint(equalToConstant: 20)])
        loader.startAnimating()
        self.view.addSubview(tableView)
        self.tableView.isHidden = true
        self.slider.isHidden = true
        self.sliderValue.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor), tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20), tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(slider)
        slider.minimumValue = 1
        slider.maximumValue = 50
        slider.value = 10
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([slider.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 10), slider.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -150), slider.heightAnchor.constraint(equalToConstant: 40), slider.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        
        sliderValue.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sliderValue)
        NSLayoutConstraint.activate([sliderValue.leadingAnchor.constraint(equalTo: self.slider.trailingAnchor,constant: 10), sliderValue.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0), sliderValue.heightAnchor.constraint(equalToConstant: 40), sliderValue.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        sliderValue.text = "\(slider.value)"
        // Do any additional setup after loading the view.
    }
    
    
    func checkForLocationPermissions() {
        
        locManager.delegate = self
        // check if location is provided
        //todo: better API, add alert
        if CLLocationManager.authorizationStatus() == .denied {
            print("Pls enable location")
            let alert = UIAlertController(title: "Pls enable location", message: nil, preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                alert.dismiss(animated: true)
            })
            self.present(alert, animated: true)
        }
        if
           !(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
            locManager.requestWhenInUseAuthorization()
        }
        if let location = locManager.location?.coordinate {
            presenter.fetchLocationsFromServer(page: "1",lat: "\(location.latitude)", long: "\(location.longitude)")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkForLocationPermissions()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = round(sender.value)
        sliderValue.text = "\(value)"
        presenter.setDistance(distance: "\(value)")
    }

}


extension LocationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getLocations()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        let location = presenter.getLocationAtIndex(index: indexPath.row)
        config.text = location?.name
        config.secondaryText = location?.address
        config.image = UIImage(named: "test")
        cell.contentConfiguration = config
        return cell
    }
    
}

extension LocationsVC: LocationViewDelegate {
    func reloadLocationTable() {
        self.tableView.isHidden = false
        self.slider.isHidden = false
        self.slider.isHidden = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}
