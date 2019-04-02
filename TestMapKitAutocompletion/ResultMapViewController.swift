//
//  ResultMapViewController.swift
//  TestMapKitAutocompletion
//
//  Created by Rob on 02/04/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import MapKit
import UIKit



final class ResultMapViewController: UIViewController {
    
    // MARK: View Properties
    
    @IBOutlet weak var informationLabel: UILabel!
    
    var mapItem: MKMapItem?
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fillLabel()
        self.showMarker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = mapItem?.placemark.title
    }
    
    // MARK: View Methods
    
    private func fillLabel() {
        if let mapItem = self.mapItem {
            let text = "Name: \(mapItem.placemark.name ?? "-")\n" +
            "Thoroughfare: \(mapItem.placemark.thoroughfare ?? "-")\n" +
            "SubThoroughfare: \(mapItem.placemark.subThoroughfare ?? "-")\n" +
            "Locality: \(mapItem.placemark.locality ?? "-")\n" +
            "SubLocality: \(mapItem.placemark.subLocality ?? "-")\n" +
            "Administrative area: \(mapItem.placemark.administrativeArea ?? "-")\n" +
            "SubAdministrative area: \(mapItem.placemark.subAdministrativeArea ?? "-")\n" +
            "Postal code: \(mapItem.placemark.postalCode ?? "-")\n" +
            "ISO country code: \(mapItem.placemark.isoCountryCode ?? "-")\n" +
            "Country: \(mapItem.placemark.country ?? "-")\n" +
            "Inland water: \(mapItem.placemark.inlandWater ?? "-")\n" +
            "Ocean: \(mapItem.placemark.inlandWater ?? "-")\n" +
            "Areas of interest: \(mapItem.placemark.areasOfInterest?.joined(separator: ",") ?? "-")"
            self.informationLabel.text = text
        }
    }
    
    private func showMarker() {
        if let mapItem = self.mapItem {
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapItem.placemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(MKCoordinateRegion(center: mapItem.placemark.coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        }
    }
    
}
