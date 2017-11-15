//
//  MapaViewController.swift
//  TablaPlatos
//
//  Created by Mariana Villamizar on 11/14/17.
//  Copyright © 2017 isis3510. All rights reserved.
//

import UIKit
import GoogleMaps

class MapaViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBAction func cerrarVentana(_ sender: Any) {
        self.dismiss(animated: true){
            
        }
    }
    
    func agregarMarcador(latitud: Double, longitud: Double) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:latitud, longitude:longitud)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        agregarMarcador(latitud: mapView.camera.target.latitude, longitud: mapView.camera.target.longitude)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
