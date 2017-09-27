//
//  PedidoViewController.swift
//  TablaPlatos
//
//  Created by macuser on 9/13/17.
//  Copyright © 2017 isis3510. All rights reserved.
//

import UIKit
import AFNetworking
import CoreLocation
import CoreMotion

var metodoSeleccionado: String = "Efectivo"

class PedidoViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation!
    var motionManager: CMMotionManager!
    
    var platoSeleccionado: Plato!
    @IBOutlet weak var lugarTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var labelMetodoPago: UILabel!
    
    @IBOutlet weak var labelInfoAcelerometro: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewDidLoad")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        userLocation = nil
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelMetodoPago.text = "Pago con " + metodoSeleccionado
        print("view will appear")
    }
    
    
    @IBAction func tomarFoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            imagePreview.image = image
        }
        
        
    }
    
    
    @IBAction func seleccionarFoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func obtenerInfoAcelerometro(_ sender: Any) {
        
        if let accelerometerData = motionManager.accelerometerData{
            labelInfoAcelerometro.text = "X:" + String(accelerometerData.acceleration.x) +
        " Y:" + String(accelerometerData.acceleration.y) +
            " Z:" + String(accelerometerData.acceleration.z)
        }
        
    }
    
    
    @IBAction func hacerPedido(_ sender: Any) {
        
        if nombreTextField.text == nil || nombreTextField.text == "" {
            showAlert(title: "Nombre vacio", message: "Debe agregarlo", closeButtonTitle: "Cerrar")
        }
        if lugarTextField.text == nil || lugarTextField.text == "" {
            showAlert(title: "Lugar vacio", message: "Debe agregarlo", closeButtonTitle: "Cerrar")
        }
        
       
        
        
        let params: [String: Any] = [
        "platoId":String( platoSeleccionado.id ),
        "cliente":nombreTextField.text!,
        "lugar":lugarTextField.text!
        ]
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.post("/pedidos", parameters: params, progress: { (progress) in
            
        }, success: { (URLSessionDataTask, response) in
            let dictionaryResponse: NSDictionary =  response! as! NSDictionary
            print(dictionaryResponse)
            
            let alertController = UIAlertController(title: "Pedido Exitoso", message: dictionaryResponse["msg"] as? String, preferredStyle: .alert)
            let volverAction = UIAlertAction(title: "Volver a platos", style: .default){
                (action: UIAlertAction) in
                self.dismiss(animated: true, completion:
                    nil
                )
            }
            alertController.addAction(volverAction)
            self.present(alertController, animated: true){
            }

            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error task \(task) -- Error Response \(error) ")
            
            self.showAlert(title: "Error en la solicitud", message: error.localizedDescription, closeButtonTitle: "Cerrar")

        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title:String, message:String, closeButtonTitle:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: closeButtonTitle, style: .default){
            (action: UIAlertAction) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true){
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        if userLocation == nil{
            userLocation = latestLocation
        }
        
        print(String(userLocation.coordinate.latitude) + ", " + String(userLocation.coordinate.longitude))
        locationLabel.text = "Ubicacion: " + String(userLocation.coordinate.latitude) + ", " + String(userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Locarion Manager Error: " + error.localizedDescription)
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
