//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Danny Espina on 10/2/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var index: Int!
    var southCarolina, miami, chile: CLLocationCoordinate2D!
    var deselect: MKAnnotation?
    
    var string1 = "Hialeah, FL"
    var string1s = NSLocalizedString("The town I was born", comment: "Brith city")
    var string2 = "Duncan, SC"
    var string2s = NSLocalizedString("Where I live now", comment: "City I live in")
    var string3 = "Vina Del Mar, Chile"
    var string3s = NSLocalizedString("City that I would like to live in", comment: "dream city")
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        
        // Set it as *the* view of this view controller
        view = mapView
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        mapView.delegate = self
        initLocalizationButton()
        
        southCarolina = CLLocationCoordinate2D(latitude: 34.8899, longitude: -82.0936)
        miami = CLLocationCoordinate2D(latitude: 25.8282, longitude: -80.2789)
        chile = CLLocationCoordinate2D(latitude: -33.0214, longitude: -71.5577)

        
       
        initPinButton()
    }
    func initLocalizationButton(){
        let localizationButton = UIButton.init(type: .system)
        let localString = NSLocalizedString("Locate Me", comment: "button string to locate user")
        localizationButton.setTitle(localString, for: .normal)
        localizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localizationButton)
        
        //Constraints
        let topConstraint = localizationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10)
        let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = localizationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        localizationButton.addTarget(self, action: #selector(MapViewController.showLocalization(_:)), for: .touchUpInside)
    }
    func initPinButton() {
        let pinButton = UIButton.init(type: .system)
        let pinString = NSLocalizedString("Instresting Locations", comment: "button text for pins")
        pinButton.setTitle(pinString, for: .normal)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinButton)
        
        //Constraints
        let topConstraint = pinButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 45)
        let leadingConstraint = pinButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = pinButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        pinButton.addTarget(self, action: #selector(MapViewController.exchangePinsLocations(_:)), for: .touchUpInside)
    }
    @objc func exchangePinsLocations(_ sender: UIButton){
        switch index {
        case nil:
            index = 0
            point(title: string1, subTitle: string1s, coordinate: southCarolina)
        case 2:
            mapView.removeAnnotation(deselect!)
            index = 0
            point(title: string1, subTitle: string1s, coordinate: southCarolina)
        case 0:
            mapView.removeAnnotation(deselect!)
            index = 1
            point(title: string2, subTitle: string2s, coordinate: miami)
        case 1:
            mapView.removeAnnotation(deselect!)
            index = 2
            point(title: string3, subTitle: string3s, coordinate: chile)
        default:
            break
        }
        
    }
    private func point(title: String!, subTitle: String!, coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
        
        let point = MKPointAnnotation()
        point.coordinate = coordinate
        point.title = title
        point.subtitle = subTitle
        mapView.addAnnotation(point)
        deselect = point
    }

    @objc func showLocalization(_ sender: UIButton!) {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = !mapView.showsUserLocation
        if mapView.showsUserLocation == true {
            
            sender.setTitle("Hide Location", for: .normal)
        }
        else {
            sender.setTitle("Show Location", for: .normal)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    @objc func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }

}
