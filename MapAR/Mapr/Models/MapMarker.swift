//
//  Marker.swift
//  MapAR
//
//  Created by jdees on 6/17/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation

struct MapMarker : Codable{
    var id: String = ""
    var mapId: String = ""
    var gameId: String = ""
    var x: Int = 0
    var y: Int = 0
    var name: String = ""
    var description: String? = ""
    var imageUri: String = ""
}
