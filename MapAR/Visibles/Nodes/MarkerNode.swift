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

    let box : SCNBox = SCNBox(width: 100, height: 100, length: 100, chamferRadius: 0)
    public var markerId : String = "" {
        didSet {}
    }
    
    public var x : Int = 0
    public var y : Int = 0
    
    init(markerId: String) {
        super.init()
        setup()
        self.markerId = markerId
    }
    
    override init(){
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        box.firstMaterial?.diffuse.contents = UIColor.red
        self.geometry = box
    }
}
