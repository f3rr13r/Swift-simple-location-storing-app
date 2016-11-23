//
//  MapViewController.swift
//  Memorable Places
//
//  Created by Harry Ferrier on 8/8/16.
//  Copyright © 2016 CASTOVISION LIMITED. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    
    // Create an instance of the CLLocationManager class
    var manager: CLLocationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Set up Long Press Gesture Recognizer with a function 'longPress' to be fired off when it is acknowledged.
        
        let uilpgr: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPressWith(gestureRecognizer:)))
        
        // Set the minimum press duration to be 2 seconds.
        uilpgr.minimumPressDuration = 2.0
        
        // And set it on the map
        map.addGestureRecognizer(uilpgr)
        
        
        
        
        
        
        // Check to see if activePlace is or is not equal to -1. Why?
        
        // We have set activePlace as default to -1, but whenever a table row is clicked, activePlace value will be changed to the value of the indexPath at that row...
        
        // If it is -1, then the user must have arrived on the map page by clicked the '+' button, and therefore they should have their current device location displayed to them. If it is NOT -1, then the user must have clicked on a valid table row, which will contain a stored location which we will need to display..
        
        
        
        // Active place is equal to -1, so this must be the user entering the map using the '+' button. In this case, we must display their current location.
        if activePlace == -1 {
            
            
           // Set up the manager preferences, ask the user for their authorization and, if they say yes, start updating location..
           manager.delegate = self
           manager.desiredAccuracy = kCLLocationAccuracyBest
           manager.requestWhenInUseAuthorization()
           manager.startUpdatingLocation()
            
            
         
            
        // activePlace wasn't equal to -1, so this must be a stored location..
        } else {
        
            
            
           // If there are more items stored in the places array than the value currently assigned to activePlace (there should be, as the array's count property starts at 1, whereas indexPath counts start from zero.
            
            if places.count > activePlace {
            
                
                // Check to see if the stored value at indexPath value [activePlace] within the places array has a value assigned to each of the following keys:
                
                // Name;
                // Latitude;
                // Longitude;
                
                if let name = places[activePlace]["name"],
                   let lat = places[activePlace]["latitude"],
                   let lon = places[activePlace]["longitude"] {
                    
                    
                    // If it does, then this means that we can get a coordinate from it to display on the map..
                    
                    
                   // Next, check to see if the values of lat and lon (the above constants) are castable to type Double...
                    
                   if let latitude = Double(lat),
                      let longitude = Double(lon) {
                    
                    
                    
                    
                        // If they are... ** SET UP DISPLAY FOR MAPVIEW **
                    
                    
                    
                        // Create a span, defining the values of latitude and longitude delta directly into the parenthesis.
                    
                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    
                    
                        // Create a CLLocationCoordinate2D using the latitude and longitude values obtained above..
                    
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    
                        // Use a combination of the coordinate2D and the coordinateSpan to get a region for the map to display..
                    
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    
                        // Finally, set the map to display that region to the user.
                    
                        self.map.setRegion(region, animated: true)
                    
                    
                    
                    
                        // ** ALSO SET UP POINT ANNOTATION TO ACCOMPANY THE LOCATION.. **
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = coordinate
                    
                    annotation.title = name
                    
                    annotation.subtitle = "Lat: \(lat), Lon: -\(lon)"
                    
                    map.addAnnotation(annotation)
                    
                    }
                
                }
            
            }
        
        }
        
    }
    
    
    // LONG PRESS WITH GESTURE RECOGNIZER function
    
    func longPressWith(gestureRecognizer: UIGestureRecognizer) {
        
        
        // Prevent gesture recognizer from picking up more than one long press at a time
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
    
            
            // Location the point of the user long press
            
            let touchPoint = gestureRecognizer.location(in: self.map)
            
            
            // Work out the new coordinate of the long press based on the original coordinate..
            
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            
            
            
            
            
            
            // ** HANDLE ADDRESS OF COORDINATE USING GEOCODER
            
            
            // Creat empty title variable to be appended with address information
            var title = ""
            
            
            // Create a location based on the newCoordinates latitude and longitude degrees
            let location: CLLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            // Create an instance of CLGeoder class
            let geoCoder = CLGeocoder()
            
            
            // use reverseGeocodeLocation method to obtain the address details of the location, and handle the return information in a closure
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                
                // If there is an error in doing so..
                if error != nil {
                
                    // Handle error
                
                    
                    
                    
                // If there is no error, and information is returned in the form of CLPlacemarks
                } else {
                
                    
                    // Create a placemark variable with the value of the first item in the returned placemarks array
                    if let placemark = placemarks?[0] {
                        
                        
                        // If the item has a property 'subThoroughfare', and that property is not empty..
                        if placemark.subThoroughfare != nil {
                        
                            // Append it to the title variable, followed by a space..
                            title += placemark.subThoroughfare! + " "
                        
                        }
                        
                        
                        // If the item has a property 'throughfare', and that property is not empty...
                        if placemark.thoroughfare != nil {
                        
                            // Append it to the title variable
                            title += placemark.thoroughfare!
                        
                        }
                    
                    }
                
                }
                
                
                // If the variable title still has a value of an empty string, and therefore there was a problem obtaining the subThoroughfare and thoroughfare values of the returned item..
                if title == "" {
                
                    // Change the value of the title variable to be the date added
                    title = "Added \(NSDate())"
                
                }
                
                
                // Create an annotation for the new location..
                let annotation: MKPointAnnotation = MKPointAnnotation()
                
                
                // Set the location of the annotation to be the newCoordinate
                annotation.coordinate = newCoordinate
                
                
                // Set the title to either be the address, or the date added, depending on the results above..
                annotation.title = title
                
                
                //Add the annotation to the map
                self.map.addAnnotation(annotation)
                
                
                // Append the new location's name and latitude and longitude coordinates to the places array.
                places.append(["name": title, "latitude": String(newCoordinate.latitude), "longitude": String(newCoordinate.longitude)])
                
                
                // Save the updated places array in core data..
                UserDefaults.standard.set(places, forKey: "places")
                
            }) // End closure
            
        }

    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
