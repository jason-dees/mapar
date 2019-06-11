

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
    
    init(from baseUrl: String){
        self.baseUrl = baseUrl
    }
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getGameData(from gameId: String) {
        
    }
}
