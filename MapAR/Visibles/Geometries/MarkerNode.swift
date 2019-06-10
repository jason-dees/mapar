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

    let box : SCNBox = SCNBox()
    public var markerId : String = "" {
        didSet {}
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
