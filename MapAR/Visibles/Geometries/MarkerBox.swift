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
    
    public var image: UIImage {
        get {
            return self.firstMaterial?.diffuse.contents as! UIImage
        }
        set(newImage) {
            self.firstMaterial?.diffuse.contents = newImage
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
