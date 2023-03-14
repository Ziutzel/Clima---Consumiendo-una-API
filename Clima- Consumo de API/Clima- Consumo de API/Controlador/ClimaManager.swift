//
//  ClimaManager.swift
//  Clima- Consumo de API
//
//  Created by Ziutzel grajales on 27/01/23.
//

import Foundation

protocol ClimaManagerDelegate {
    //dos metodos obligatorios que debe adoptar el VC

    func actualizarClima(clima: ClimaModelo) //Aqui cambiamos de climaData a climamodelo
    func huboError(cualError : String )
    
}


struct ClimaManager {
   
    var delegado : ClimaManagerDelegate?
    
    let climaUrl = "https://api.openweathermap.org/data/2.5/weather?appid=698cb29c0a1e70d1a30a0a9982f6a95a&units=metric&lang=es"
    
    
    //Esta funcion extrae el nombre de la ciudad que escribe el usuario en el texto
    
    func fetchClima(nombreCiudad : String) {
//Concatenar la urlString base con la busq del usuario
        let urlString = "\(climaUrl)&q=\(nombreCiudad)"
        realizarSolicitud(url: urlString)
        
    }
    
    func fetchClima(lat: Double, lon: Double){
        let urlString = "\(climaUrl)&lat=\(lat)&lon=\(lon)"
        
        realizarSolicitud(url: urlString)
    }
    
    func realizarSolicitud(url: String){
        //1.- Crear un obj URL
        if let url = URL(string: url){
            
            //2.- Crear una sesion
            let session = URLSession(configuration: .default)
            
            //3.- Asignar una tarea a la sesion
            let tarea = session.dataTask(with: url) { data, respuesta, error in
               
                
                if let datosSeguros = data {
                    ///extraer la informacion
                
                    if let datosClima = self.parseJSON(climaData: datosSeguros) {
                        delegado?.actualizarClima(clima: datosClima)
                    }
                }
            }
            //4.- Comenzar la tarea
            tarea.resume()
        }
    }  // cierre de la funcion realizar solicitud



//Este metodo me ayuda a decodificar la data y poder leerla una vez que se obtuvo

    func parseJSON(climaData : Data) -> ClimaModelo? {
    
        let decoder = JSONDecoder()
        
        do {
            let dataDecodificada = try decoder.decode(ClimaData.self, from: climaData)
            ///crear el objeto Personalizado (ClimaModelo)
            let id = dataDecodificada.weather[0].id
            let nombre = dataDecodificada.name
            let descripcion = dataDecodificada.weather[0].description
            let temp = dataDecodificada.main.temp
            let tempMax = dataDecodificada.main.temp_max
            let tempMin = dataDecodificada.main.temp_min
            let sensacionTermica = dataDecodificada.main.feels_like
            
            let obClimaModelo = ClimaModelo(condicionID: id, nombreCiudad: nombre, descripcionClima: descripcion, temperaturaCelcius: temp , tempMaxima: tempMax , tempMinima: tempMin , sensacion: sensacionTermica)
            
            return obClimaModelo
        } catch {
            print("Debug: error \(error.localizedDescription)")
            return nil
        }
    }
    
}// cierre de la struct
        
    
