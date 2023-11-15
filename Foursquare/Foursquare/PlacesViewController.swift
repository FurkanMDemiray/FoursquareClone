//
//  PlacesViewController.swift
//  Foursquare
//
//  Created by Melik Demiray on 13.11.2023.
//

import UIKit
import ParseCore

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var nameArray = [String]()
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()
    var imageArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutClicked))
        getData()
        print(nameArray.count)
        print(nameArray)
    }


    @objc func logOutClicked() {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }

    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        //cell.imageView?.image = imageArray[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PlacesModel.sharedInstance.name = nameArray[indexPath.row]
        PlacesModel.sharedInstance.latitude = String(latitudeArray[indexPath.row])
        PlacesModel.sharedInstance.longitude = String(longitudeArray[indexPath.row])
        PlacesModel.sharedInstance.image = imageArray[indexPath.row]
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }

    func makeAlert(title: String, message: String) {

        // make alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)

    }


    func getData() {

        let query = PFQuery(className: "places")
        query.findObjectsInBackground { objects, error in
            if let err = error {
                self.makeAlert(title: "Error", message: err.localizedDescription)
            } else {
                if let objects = objects {

                    self.nameArray.removeAll(keepingCapacity: false)
                    self.latitudeArray.removeAll(keepingCapacity: false)
                    self.longitudeArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)

                    for object in objects {

                        if let placeName = object.object(forKey: "name") as? String {
                            self.nameArray.append(placeName)
                        }
                        if let placeLatitude = object.object(forKey: "latitude") as? Double {
                            self.latitudeArray.append(placeLatitude)
                        }
                        if let placeLongitude = object.object(forKey: "longitude") as? Double {
                            self.longitudeArray.append(placeLongitude)
                        }
                        if let placeImage = object.object(forKey: "image2") as? PFFileObject {
                            placeImage.getDataInBackground { data, error in
                                if let imageData = data {
                                    if let image = UIImage(data: imageData) {
                                        self.imageArray.append(image)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

}
