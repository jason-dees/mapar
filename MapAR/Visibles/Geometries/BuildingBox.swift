//
//  BuildingBox.swift
//  MapAR
//
//  Created by Jason Dees on 6/2/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class BuildingBox : SCNBox{
    
    public var diffuseColor : UIColor {
        get {
            return self.firstMaterial?.diffuse.contents as! UIColor
        }
        set(newColor){
            self.firstMaterial?.diffuse.contents = newColor
        }
    }
    
    public var metalnessColor : UIColor {
        get {
            return self.firstMaterial?.metalness.contents as! UIColor
        }
        set(newColor){
            self.firstMaterial?.metalness.contents = newColor
        }
    }
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
