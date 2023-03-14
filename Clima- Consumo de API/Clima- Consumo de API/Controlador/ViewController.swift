//
//  ViewController.swift
//  Clima- Consumo de API
//
//  Created by Ziutzel grajales on 27/01/23.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {

    @IBOutlet weak var nombreCiudadTextField: UITextField!
    @IBOutlet weak var climaImage: UIImageView!
    
    @IBOutlet weak var temperaturaLabel: UILabel!
    
    @IBOutlet weak var descripcionClimaLabel: UILabel!
    
    @IBOutlet weak var fondoImage: UIImageView!
    
    
    
    var climaManager = ClimaManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        climaManager.fetchClima(nombreCiudad: "Mexico")
        nombreCiudadTextField.delegate = self
        climaManager.delegado = self
        
        locationManager.delegate = self
        
        //Solicitar el permiso
        locationManager.requestWhenInUseAuthorization()
        
    }

    @IBAction func ubicacionButton(_ sender: UIButton) {
        //Acceder a la ubicacion
        locationManager.requestLocation()
        
    }
    
    @IBAction func buscarButton(_ sender: UIButton) {
        
        climaManager.fetchClima(nombreCiudad: nombreCiudadTextField.text ?? "oaxaca")
        nombreCiudadTextField.text = ""
        //ocultamos el teclado virtual
        nombreCiudadTextField.endEditing(true)
    }
    
}

// MARK: - GPS
extension ViewController: CLLocationManagerDelegate {
    
    //Se ejecuntan despues de locationManager.requestLocation()
    //Cuando se obtuvo la ubicacion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Se detectó la ubicacion del usuario")
        if let ubicacion = locations.last {
            print("Ubicacion: \(ubicacion)")
            
            let latitud = ubicacion.coordinate.latitude
            let longitud = ubicacion.coordinate.longitude
            
            print(latitud)
            print(longitud)
            climaManager.fetchClima(lat: latitud, lon: longitud)
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("No se obtuvo la ubicacion del usuario")
    }
    
    //cada vez que cambian los permisos
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            //Acceder a la ubicacion
            locationManager.requestLocation()
        case .authorized:
            print("authorized")
        @unknown default:
            fatalError("Error desconocido :/")
        }
    }
    
    
}


//MARK: creamos extension para adoptar el protocolo de mi ClimaManagerDelegate

extension ViewController : ClimaManagerDelegate {
    
    func actualizarClima(clima: ClimaModelo) {
        
        print("clima desde el VC: \(clima)")
        
        DispatchQueue.main.async {
            self.descripcionClimaLabel.text = "En \(clima.nombreCiudad) el clima esta: \(clima.descripcionClima) con una temperatura maxima de : \(clima.tempMaxima) C° , una temperatura minima de : \(clima.tempMinima) C° y sensacion termica de : \(clima.sensacion) C°"
            
            self.temperaturaLabel.text = clima.temperaturaConUnDecimal
            self.climaImage.image = UIImage(systemName: "\(clima.condicionClima)")
            self.fondoImage.image = UIImage(named: "\(clima.fondoClima)")
        }
        
    }
    
    func huboError(cualError: String) {
        
    }
    
}



//MARK: Protocolos para mi textField

extension ViewController : UITextFieldDelegate {
    
//1._Habilitar el boton del teclado virtual, recordemos que en la propiedad del textField en el return key le pusimos "search", ese buscar aparecera en mi teclado cuando escriba en el textfield y tendrá la funcion de buscar cuando el usuario haga click
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("Buscar Clima ")
        
    //ocultar el teclado ...Este metodo no es necesario y utilizamos el paso 2
        nombreCiudadTextField.endEditing(true)
        return true
    }
    
//2._ Idetificar cuando el usuario termina de editar y que pueda borrar el contenido del textfield
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print ("Buscar Clima textfielddidendediting")
        //para identificar en mi pantalla cuando se activa la func
        
        climaManager.fetchClima(nombreCiudad: nombreCiudadTextField.text ?? "Mexico")
        
    //Despues de buscar voy a limpiar mi textfield
        nombreCiudadTextField.text = ""
        
    //Ocultamos el teclado
        nombreCiudadTextField.endEditing(true)
    }
    
//3._ Evitar que el usuario no escriba nada
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if nombreCiudadTextField.text != "" {
            return true
        } else {
    //Indicar al usuario con el placeholder que escriba algo
            nombreCiudadTextField.placeholder = "Escribe una ciudad o pais"
            return false
        }
    }
    
}
