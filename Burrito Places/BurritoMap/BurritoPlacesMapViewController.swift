//
//  BurritoPlacesMapViewController.swift
//  Burrito Places
//
//  Created by User on 6/19/18.
//  Copyright © 2018 Jonathan King. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class BurritoPlacesMapViewController: UIViewController {
    
    var mapView: GMSMapView?
    var place: GMSPlace?
    var places: [GMSPlace]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        prepareMap()
        
        
    }
    
    fileprivate func setupUI() {
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextLocation))
        
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        
    }
    

}


