//
//  ViewController.swift
//  TablaPlatos
//
//  Created by macuser on 9/12/17.
//  Copyright © 2017 isis3510. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewPlatos: UITableView!
    var platos:[Plato] = [Plato]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("Llega hasta aqui")
        // Do any additional setup after loading the view, typically from a nib.
        tableViewPlatos.delegate = self
        tableViewPlatos.dataSource = self
        
       getPlatos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


