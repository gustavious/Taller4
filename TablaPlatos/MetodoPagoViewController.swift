//
//  MetodoPagoViewController.swift
//  TablaPlatos
//
//  Created by macuser on 9/20/17.
//  Copyright © 2017 isis3510. All rights reserved.
//

import UIKit

class MetodoPagoViewController: UIViewController {
    
    
    struct ConstantsSegmented{
        let Credito = 0
        let Debito = 1
        let Efectivo = 2
    }

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var segmentedPago: UISegmentedControl!
    
    var timerRest: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingSpinner.startAnimating()
        segmentedPago.isHidden = true
        timerRest = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(getMetodosPago), userInfo: nil, repeats: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMetodosPago() {
        loadingSpinner.stopAnimating()
        segmentedPago.isHidden = false
    }
    
    
    @IBAction func cambioMetodoPago(_ sender: Any) {
    
        if segmentedPago.selectedSegmentIndex == ConstantsSegmented().Credito {
            metodoSeleccionado = "Credito"
        } else if segmentedPago.selectedSegmentIndex == ConstantsSegmented().Debito {
            metodoSeleccionado = "Debito"
        } else if segmentedPago.selectedSegmentIndex == ConstantsSegmented().Efectivo {
            metodoSeleccionado = "Efectivo"
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        timerRest.invalidate()
    }
    
    @IBAction func confirmar(_ sender: Any) {
        dismiss(animated: true) { 
            
        }
    }
    @IBAction func dimissView(_ sender: Any) {
        self.dismiss(animated: true) { 
            
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
