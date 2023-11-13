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

        // Harita görünümü delegesini ayarla

    }

    @objc func addAnnotation(gestureRecognizer: UILongPressGestureRecognizer, title: String) {

        if gestureRecognizer.state == .began {
            // Uzun basma başladığında yapılacak işlemler
            let touchPoint = gestureRecognizer.location(in: mapkit)
            let coordinate = mapkit.convert(touchPoint, toCoordinateFrom: mapkit)

            // Yeni bir annotation oluştur
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = coordinate
            newAnnotation.title = title
            newAnnotation.subtitle = "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)"

            // Harita üzerine yeni annotation'ı ekle
            mapkit.addAnnotation(newAnnotation)
        }
    }


    @objc func chooseImage() {

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)

    }


    @IBAction func saveButtonClicked(_ sender: Any) {
    }
}
