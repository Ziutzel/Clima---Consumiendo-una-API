//
//  ClimaModelo.swift
//  Clima- Consumo de API
//
//  Created by Ziutzel grajales on 27/01/23.
//

import Foundation


struct ClimaModelo {
    let condicionID: Int
    let nombreCiudad: String
    let descripcionClima: String
    let temperaturaCelcius: Double //14.56
    let tempMaxima : Double
    let tempMinima : Double
    let sensacion : Double
    
    //Propiedad computada
    var temperaturaConUnDecimal: String {
        return String(format: "%.1f", temperaturaCelcius) //14.5
    }
    
    var fondoClima: String {
        switch condicionID {
        case 200...232:
            return "despejado"
        case 300...321:
            return "llovizna"
        case 400...431:
            return "cieloclaro"
        case 500...531:
            return "nubes"
        case 600...622:
            return "nevando"
        case 701...781:
            return "soleado"
        case 800:
            return "cieloclaro"
        case 801...804:
            return "soleado"
        default:
            return "cloud"
        }
    }
    
    var condicionClima: String {
        switch condicionID {
        case 200...250:
            return "cloud.bolt"
        case 300...350:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.bolt.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
