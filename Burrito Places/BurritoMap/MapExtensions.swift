//
//  MapExtensions.swift
//  Burrito Places
//
//  Created by User on 6/20/18.
//  Copyright © 2018 Jonathan King. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension BurritoPlacesMapViewController {
    
    
    
    @objc func nextLocation() {
        
        guard let places = self.places else { return }
        guard let place = self.place else { return }
        guard let  index = places.index(of: place) else { return }
        var number = index + 1
        
        if self.place == places.last {
            number = 0
        }
        let next = places[number]
        self.place = next
        mapView?.camera = GMSCameraPosition.camera(withLatitude: next.coordinate.latitude, longitude: next.coordinate.longitude, zoom: 15)
        let marker = GMSMarker(position: next.coordinate)
        self.title = place.name
        marker.title = place.name
        marker.snippet = place.priceLevel.rawValue.dollarSign
        marker.map = mapView
        marker.icon = #imageLiteral(resourceName: "mapIcon-1x")
    }
    
    func prepareMap() {
        
        guard let place = self.place else { return }
        self.navigationItem.title = place.name
        let cameraPosition = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: cameraPosition)
        
        let currentLocation = place.coordinate
        let marker = GMSMarker(position: currentLocation)
        marker.title = place.name
        marker.snippet = place.priceLevel.rawValue.dollarSign
        marker.map = mapView
        marker.icon = #imageLiteral(resourceName: "mapIcon-1x")
        
        self.view = mapView
    }
    
}




