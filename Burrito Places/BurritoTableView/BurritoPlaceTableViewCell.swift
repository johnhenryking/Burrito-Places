//
//  BurritoPlaceTableViewCell.swift
//  Burrito Places
//
//  Created by User on 6/19/18.
//  Copyright © 2018 Jonathan King. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class BurritoPlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        self.customize()
    }
    
    var place: GMSPlace? {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        
        guard let place = place else { return }
        titleLabel.text = place.name
        addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
            .joined(separator: "\n")
        var phoneNumber = place.phoneNumber
        phoneNumber?.removeFirst()
        descriptionLabel.text = "\(place.priceLevel.rawValue.dollarSign) • \(phoneNumber ?? "")"
        
    }
    

}
