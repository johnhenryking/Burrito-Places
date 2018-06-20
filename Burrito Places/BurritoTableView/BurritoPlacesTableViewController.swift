//
//  BurritoPlacesTableViewController.swift
//  Burrito Places
//
//  Created by User on 6/19/18.
//  Copyright © 2018 Jonathan King. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

let reuseIdentifier = "Cell"

class BurritoPlacesTableViewController: UITableViewController {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var likelyPlaces: [GMSPlace] = []
    
    var bounds: CLLocationCoordinate2D? {
        didSet {
            // get burrito places once location has been established
            self.placeAutocomplete()
        }
    }
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleLocationManager()
        
    }
    
    var places = [GMSPlace]()

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BurritoPlaceTableViewCell
        cell.place = places[indexPath.section]
        return cell
    }
    
    // Show only the first five items in the table (scrolling is disabled in IB).
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height/5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let map = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "Map") as! BurritoPlacesMapViewController
        map.places = places
        map.place = places[indexPath.section]
        navigationController?.show(map, sender: self)
    }
    
    
    
    
    
    

}
