//
//  MarkerBox.swift
//  MapAR
//
//  Created by jdees on 6/21/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MarkerBox : SCNBox {
    
    override init(){
        super.init()
        let reflectiveMaterial = SCNMaterial()
        reflectiveMaterial.lightingModel = .physicallyBased
        reflectiveMaterial.metalness.contents = 0
        reflectiveMaterial.roughness.contents = 1.0
        self.firstMaterial = reflectiveMaterial
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var image: UIImage {
        get {
            return self.firstMaterial?.metalness.contents as! UIImage
        }
        set(newImage) {
            self.firstMaterial?.metalness.contents = newImage
        }
    }
    
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
    
}
