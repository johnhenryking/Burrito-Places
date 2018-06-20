//
//  Extensions.swift
//  Burrito Places
//
//  Created by User on 6/19/18.
//  Copyright © 2018 Jonathan King. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension BurritoPlacesTableViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.bounds = locValue
        print("locations = \(locValue.latitude) \(locValue.longitude)")
      
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    
    func placeAutocomplete() {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        let bounds = GMSCoordinateBounds(coordinate: self.bounds!, coordinate: self.bounds!)
        placesClient.autocompleteQuery("Burrito", bounds: bounds, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                    
                    guard let placeID = result.placeID else { return }
                    
                    self.placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                        if let error = error {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let place = place else {
                            print("No place details for \(placeID)")
                            return
                        }
                        if self.places.contains(place) == false {
                            self.places.append(place)
                        }
                        //**MARK: I have to call reload data here to meet design requirements.
                        // Typically I would call reload rows or reload sections in the previous function
                        self.tableView.reloadData()
                        print("Place name \(place.name)")
                        print("Place address \(place.formattedAddress)")
                        print("Place placeID \(place.placeID)")
                        print("Place attributions \(place.attributions)")
                    })
                    
                }
                print("COUNT ", self.places.count)
            }
        })
    }
    
    
    func handleLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    
    // customization functions
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tableView.frame.size.height/30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.tableView.frame.size.height/30
        }
        return 0
    }
    
}

extension BurritoPlaceTableViewCell {
    
    func customize() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -5, height: 5)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 12.0
        layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        let indicator = #imageLiteral(resourceName: "detailedEncloser-1x")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: indicator)
    }
    
    
}

extension Int {
    var dollarSign: String {
        if self == 0 {
            return "$"
        }
        if self == 1 {
            return "$$"
        }
        if self == 2 {
            return "$$$"
        }
        if self == 3 {
            return "$$$$"
        }
        if self == 4 {
            return "$$$$$"
        } else {
            return ""
        }
    }
}


