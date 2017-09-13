//
//  PedidoViewController.swift
//  TablaPlatos
//
//  Created by macuser on 9/13/17.
//  Copyright © 2017 isis3510. All rights reserved.
//

import UIKit
import AFNetworking

class PedidoViewController: UIViewController {
    
    var platoSeleccionado: Plato!
    @IBOutlet weak var lugarTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
