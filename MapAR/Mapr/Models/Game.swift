//
//  Game.swift
//  MapAR
//
//  Created by jdees on 6/17/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation

class Game : Codable {
    var id: String = ""
    var owner: String = ""
    var name: String = ""
    var isPrivate: Bool = false
    var lastPlayed: String = ""
    var primaryMapId: String = ""
    var maps: [GameMap] = []
    init(){}
}
