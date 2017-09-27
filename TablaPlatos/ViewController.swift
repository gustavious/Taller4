//
//  ViewController.swift
//  TablaPlatos
//
//  Created by macuser on 9/12/17.
//  Copyright © 2017 isis3510. All rights reserved.
//

import UIKit
import AFNetworking
import Contacts
import ContactsUI
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var tableViewPlatos: UITableView!
   
    var platos:[Plato] = [Plato]()
    let contactPicker: CNContactPickerViewController = CNContactPickerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view, typically from a nib.
        tableViewPlatos.delegate = self
        tableViewPlatos.dataSource = self
        //contactPicker.delegate = self
        
        
       getPlatos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    @IBAction func compartirPlato(_ sender: Any) {
        self.present(contactPicker, animated:true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            print("Message sent:")
        case .failed:
            print("Message failes")
        case .cancelled:
            print("Message Cancelled")
        }
    }
    
    func sendSMS(contact: CNContact){
        if !MFMessageComposeViewController.canSendText(){
            print("No es posible enviar mensajes en este dispositivo")
            return
        }
        
        if contact.phoneNumbers.count > 0{
            
            let recipents: [String] = [contact.phoneNumbers[0].value.stringValue, "3166420466"]
            let messageController: MFMessageComposeViewController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.recipients = recipents
            messageController.body = "Mensaje de prueba"
            
            self.present(messageController, animated: true, completion: nil)
        }
        else {
            print("El contacto no tiene numeros telefonicos")
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated:true){
         self.sendSMS(contact: contact)
        }
    }
    
    @IBAction func compartirPlatoWhatsApp(_ sender: Any) {
        let msg = "Mensaje de prueba"
        let urlWhats = "whatsapp://send?text=\(msg)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            
            if let whatsappURL = URL(string: urlString){
                if UIApplication.shared.canOpenURL(whatsappURL){
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: { (completed: Bool) in
                        
                    })
                }
                else{
                    print("No se puede abrir porque no esta intalado")
                }
            }
           
        }
    }
    
    func getPlatos(){
        
        
        manager.get("/platos", parameters: nil, progress: { (progress) in
            
        }, success: { (URLSessionDataTask, response) in
            let arrayResponse: NSArray = response! as! NSArray
            print(arrayResponse)
            
            for item in arrayResponse {
                let currentPlato: Plato = Plato(item as! Dictionary<String, AnyObject>)
                self.platos.append(currentPlato)
                self.tableViewPlatos.reloadData()
            }
        }) { ( task: URLSessionDataTask? , error: Error) in
            print("Error task \(task) -- Error Response \(error) ")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return platos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlatoCell", for: indexPath)
    
        let currentPlato: Plato = platos[indexPath.row]
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.setImageWith(URL(string: currentPlato.imagen!)!)
        let labelNombre: UILabel = cell.viewWithTag(2) as! UILabel
        labelNombre.text = currentPlato.nombre!
        let labelPrecio = cell.viewWithTag(3) as! UILabel
        labelPrecio.text = String(currentPlato.precio!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPedidoView"{
            
            
          let viewController: PedidoViewController = segue.destination as! PedidoViewController
            viewController.platoSeleccionado = sender as! Plato
            print(viewController.platoSeleccionado.id)

            
          
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clickea una celda")
        let platoSeleccionado: Plato = platos[indexPath.row]
        
    
        
        self.performSegue(withIdentifier: "ShowPedidoView", sender: platoSeleccionado)
        
    }
    
    
    
  
   

   
}


