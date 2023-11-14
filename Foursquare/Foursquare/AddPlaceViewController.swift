//
//  AddPlaceViewController.swift
//  Foursquare
//
//  Created by Melik Demiray on 13.11.2023.
//

import UIKit
import MapKit
import ParseCore

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapkit: MKMapView!
    @IBOutlet weak var placeNameText: UITextField!

    var isAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        startMapkit()
        mapkit.delegate = self

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        mapkit.addGestureRecognizer(longPressRecognizer)

    }

    func startMapkit() {
        let location = CLLocation(latitude: 41.042058, longitude: 28.996780)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)

        // annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Taksim"
        annotation.subtitle = "Istanbul"
        mapkit.addAnnotation(annotation)


        mapkit.setRegion(coordinateRegion, animated: true)

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
    }
}
