//
//  MarkerNode.swift
//  MapAR
//
//  Created by jdees on 6/10/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MarkerNode : SCNNode {

    let box : MarkerBox = MarkerBox(width: 100, height: 100, length: 100, chamferRadius: 0)
    public var markerId : String
    
    public var x : Int = 0
    public var y : Int = 0
    
    public var image: UIImage {
        get{
            return box.image
        }
        set(newImage) {
            box.image = newImage
        }
    }
    
    public var color: UIColor {
        get {
            return box.metalnessColor
        }
        set(newColor) {
            box.metalnessColor = newColor
        }
    }
    
    init(newMarkerId: String) {
        markerId = newMarkerId
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        markerId = ""
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        self.geometry = box
        self.color = UIColor.red
    }
}
