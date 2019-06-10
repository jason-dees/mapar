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

    let box : SCNBox = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
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
        self.geometry = box
    }
}
