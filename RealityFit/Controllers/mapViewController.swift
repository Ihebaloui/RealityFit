//
//  mapViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 16/12/2021.
//

import UIKit
import MapKit

class mapViewController: UIViewController , UISearchBarDelegate{

    var locationManager: CLLocationManager!
    var mapView: MKMapView!
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
       // button.setImage(UIImage(systemName: "search"), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    
        return button
    }()
    
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal), for: .normal)
       // button.setImage(UIImage(systemName: "search"), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    
        return button
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        configureLocationManager()
        configureMapView()
        enableLocationServices()
        createAnnotation(locations: annotationsLocation)
    }
    
    // MARK: - Selectors
    
    @objc func handleCenterLocation() {
        centerMapOnUserLocation()
        centerMapButton.alpha = 0
    }
    
    // MARK: - Helper Functions
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func configureMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        view.addSubview(centerMapButton)
        centerMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        centerMapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        centerMapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.layer.cornerRadius = 50 / 2
        centerMapButton.alpha = 1
        
       
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
  
    
    let annotationsLocation = [

        ["title": "California Gym Ariana", "latitude": 36.86416299848621, "longitude": 10.144468421015276],
        ["title": "California Gym CUN", "latitude": 36.85062084440735 ,  "longitude":  10.196671572375736],
        ["title": "FEEL GOOD Sport Center", "latitude": 36.85172733582152, "longitude": 10.181388945465415],
        ["title": "Gym Box", "latitude":  36.85281860006909, "longitude": 10.166422524493072],
        ["title": "Gold Gym Ariana", "latitude": 36.85691542252238, "longitude": 10.202353287694374],
        ["title": "Factory gym", "latitude":  36.84187628760544, "longitude": 10.18178119459893],
        ["title": "Smart Gym", "latitude": 36.86880762483311, "longitude": 10.226551230346127],
        ["title": "My Gym", "latitude": 36.87653559427627, "longitude": 10.225956045255305],
        ["title": "Oxygym", "latitude": 36.88799791940354, "longitude": 10.165384513352329],
        ["title": "Expert Gym", "latitude": 36.89213565244602, "longitude": 10.171519498116895]


    ]
    func createAnnotation(locations: [[String : Any]]) {
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location["title"] as? String
            annotations.coordinate = CLLocationCoordinate2D(latitude: location["latitude"]as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)

            
        mapView.addAnnotation(annotations)
        }
    }
    @IBAction func userLocationTapped(_ sender: Any) {
        centerMapOnUserLocation()
    }
}

extension mapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.centerMapButton.alpha = 1
        }
    }
    
 
    }
    


// MARK: - CLLocationManagerDelegate

extension mapViewController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Location auth status is NOT DETERMINED")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location auth status is RESTRICTED")
        case .denied:
            print("Location auth status is DENIED")
        case .authorizedAlways:
            print("Location auth status is AUTHORIZED ALWAYS")
        case .authorizedWhenInUse:
            print("Location auth status is AUTHORIZED WHEN IN USE")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard locationManager.location != nil else { return }
        centerMapOnUserLocation()
    }
}

extension mapViewController {
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        switch swipe.direction.rawValue {
        case 2:
            performSegue(withIdentifier: "mapToHomeSegue", sender: self)
        default:
            break
        }
    }
}


    
  




