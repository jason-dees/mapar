

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
    
    init(from baseUrl: String = "https://maprfunctions.azurewebsites.net/api/"){
        self.baseUrl = baseUrl
    }
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getGameData(from gameId: String, completion: @escaping (NSDictionary) -> ()) {
        let mapUrl = URL(string: "https://maprfunctions.azurewebsites.net/api/games/\(gameId)")!
        MaprCommunicator.getData(from: mapUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    completion(json)
                }
                else{
                    //do some error stuff??
                }
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (Data) -> ()) {
        MaprCommunicator.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                completion(data)
            }
        }
    }
}
