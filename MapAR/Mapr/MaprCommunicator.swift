

//
//  MaprHttp.swift
//  MapAR
//
//  Created by jdees on 6/11/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation


class MaprCommunicator {
    
    let baseUrl: String
    
    init(from baseUrl: String = "https://maprfunctions.azurewebsites.net/api"){
        self.baseUrl = baseUrl
    }
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print("Getting Data from \(url)")
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private static func getImage(from url: URL, completion: @escaping (Data) -> ()) {
        MaprCommunicator.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                completion(data)
            }
        }
    }
    
    func getGameData(from gameId: String, completion: @escaping (Data) -> ()) {
        let mapUrl = URL(string: "\(baseUrl)/games/\(gameId)")!
        MaprCommunicator.getData(from: mapUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(data)
            }
        }
    }
    
    func getMapImage(from gameId: String, from mapId: String, completion: @escaping (Data) -> ()){
        let mapUrl = URL(string: "\(baseUrl)/games/\(gameId)/maps/\(mapId)/image")!
        MaprCommunicator.getImage(from: mapUrl) { data in
            completion(data)
        }
    }
}
