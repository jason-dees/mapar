//
//  Map.swift
//  MapAR
//
//  Created by jdees on 6/17/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation

struct GameMap : Codable {
    var id: String = ""
    var gameId: String = ""
    var imageUri: String = ""
    var isActive: Bool = false
    var isPrimary: Bool = false
    var markers: [MapMarker] = []
}
