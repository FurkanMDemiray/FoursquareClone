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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test"
        return cell
    }

    func makeAlert(title: String, message: String) {

        // make alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)

    }


    func getDate() {


        let query = PFQuery(className: "places")
        query.findObjectsInBackground { objects, error in
            if let err = error {
                self.makeAlert(title: "Error", message: err.localizedDescription)
            } else {
                if objects != nil {

                    self.nameArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.latitudeArray.removeAll(keepingCapacity: false)
                    self.longitudeArray.removeAll(keepingCapacity: false)

                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeLatitude = object.object(forKey: "latitude") as? String {
                                if let placeLongitude = object.object(forKey: "longitude") as? String {
                                    if let imageData = object.object(forKey: "image") as? PFFileObject {

                                        imageData.getDataInBackground { data, error in
                                            if error == nil {
                                                if data != nil {
                                                    let image = UIImage(data: data!)
                                                    self.imageArray.append(image!)
                                                    self.nameArray.append(placeName)
                                                    self.latitudeArray.append(Double(placeLatitude)!)
                                                    self.longitudeArray.append(Double(placeLongitude)!)

                                                    self.tableView.reloadData()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }



                }
            }
        }
    }

}
