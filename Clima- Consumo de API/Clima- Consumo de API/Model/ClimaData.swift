//
//  ClimaData.swift
//  Clima- Consumo de API
//
//  Created by Ziutzel grajales on 27/01/23.
//

import Foundation

struct ClimaData : Decodable , Encodable {

    let name : String
    let weather : [Weather]
    let coord : Coord //Recordemos que cuando sólo lleva un parentesis, no es necesario ponerle algo mas
    let main : Main
    let timezone: Int
    
}


struct Weather : Codable {
    let description : String
    let id : Int //El id nos servirá para cambiar la imagen de acuerdo al estado del tiempo
}

struct Coord : Codable {
   let  lat : Double
    let lon : Double
}

struct Main : Codable {
    
    let temp : Double
    let feels_like : Double
    let temp_min : Double
    let temp_max: Double
    
}

