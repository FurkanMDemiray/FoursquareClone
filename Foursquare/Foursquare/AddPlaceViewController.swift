//
//  AddPlaceViewController.swift
//  Foursquare
//
//  Created by Melik Demiray on 13.11.2023.
//

import UIKit
import MapKit
import ParseCore

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapkit: MKMapView!
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    var chosenLatitude = Double()
    var chosenLongitude = Double()
    var isAdded = false
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapkit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        if PlacesModel.sharedInstance.name != nil && PlacesModel.sharedInstance.isTableViewClicked == true {
            imageView.image = PlacesModel.sharedInstance.image
            placeNameText.isHidden = true
            saveButton.isHidden = true
            getSelectedLocation()
            print("İfe girdi")
        } else if PlacesModel.sharedInstance.isTableViewClicked == false {
            print("Else girdi")
            placeNameText.isHidden = false
            saveButton.isHidden = false
            imageView.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            imageView.addGestureRecognizer(gestureRecognizer)
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
            mapkit.addGestureRecognizer(longPressRecognizer)
        }

    }
    func getSelectedLocation() {
        if PlacesModel.sharedInstance.latitude != "" {
            let latitude = Double(PlacesModel.sharedInstance.latitude)
            let longitude = Double(PlacesModel.sharedInstance.longitude)
            let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
            let region = MKCoordinateRegion(center: location, span: span)
            mapkit.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = PlacesModel.sharedInstance.name
            annotation.subtitle = "\(PlacesModel.sharedInstance.longitude),\(PlacesModel.sharedInstance.latitude)"
            mapkit.addAnnotation(annotation)
            PlacesModel.sharedInstance.isTableViewClicked = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapkit.setRegion(region, animated: true)
    }
    @objc func addAnnotation(gestureRecognizer: UILongPressGestureRecognizer) {

        if placeNameText.text != "" && isAdded == false {
            if gestureRecognizer.state == .began {
                // Uzun basma başladığında yapılacak işlemler
                let touchPoint = gestureRecognizer.location(in: mapkit)
                let coordinate = mapkit.convert(touchPoint, toCoordinateFrom: mapkit)

                // Yeni bir annotation oluştur
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = coordinate
                newAnnotation.title = placeNameText.text
                newAnnotation.subtitle = "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)"
                chosenLatitude = coordinate.latitude
                chosenLongitude = coordinate.longitude

                // Harita üzerine yeni annotation'ı ekle
                mapkit.addAnnotation(newAnnotation)
                isAdded = true
            }
        } else if placeNameText.text == "" {
            makeAlert(title: "Error", message: "Please enter a place name")
        }
        else if isAdded == true {
            makeAlert(title: "Error", message: "You have already added a place")
        }



    }

    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func chooseImage() {

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func saveButtonClicked(_ sender: Any) {

        let place = PFObject(className: "places")

        place["name"] = placeNameText.text
        place["latitude"] = chosenLatitude
        place["longitude"] = chosenLongitude
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.5) {
            place["image2"] = PFFileObject(name: "image.jpg", data: imageData)
        }

        place.saveInBackground { success, error in
            if let err = error {
                self.makeAlert(title: "Error", message: err.localizedDescription)
            }
            else {
                //self.makeAlert(title: "Success", message: "Place saved")
                self.placeNameText.text = ""
                //self.imageView.image = UIImage(named: "select.png")
                self.isAdded = false
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("newPlace"), object: nil)
                // back to the former view controller
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
