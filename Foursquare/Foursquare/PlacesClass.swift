//
//  PlacesClass.swift
//  Foursquare
//
//  Created by Melik Demiray on 14.11.2023.
//

import Foundation
import UIKit
import ParseCore


class PlacesModel {

    // singleton

    var name = ""
    var image = UIImage()
    var latitude = ""
    var longitude = ""

    static var sharedInstance = PlacesModel()

    private init() {

    }

}
