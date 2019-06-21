//
//  MapPlane.swift
//  MapAR
//
//  Created by jdees on 6/21/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MapPlane : SCNPlane {
    
    public var image : UIImage = UIImage() {
        didSet {
            self.firstMaterial?.diffuse.contents = image
            self.firstMaterial?.transparency = CGFloat(1.0)
        }
    }
    public var color: UIColor = .orange {
        didSet {
            self.firstMaterial?.diffuse.contents = color
            self.firstMaterial?.transparency = CGFloat(0.5)
        }
    }
    
    func setSize(width: CGFloat, height: CGFloat){
        self.width = width
        self.height = height
    }
}
