//
//  MaprGame.swift
//  MapAR
//
//  Created by jdees on 6/11/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MaprGame {
    
    public private(set) var activeMapImageData : UIImage = UIImage()
    
    let communicator : MaprCommunicator

    init(from gameId: String){
        communicator = MaprCommunicator(from: "https://maprfunctions.azurewebsites.net")
    }
}
