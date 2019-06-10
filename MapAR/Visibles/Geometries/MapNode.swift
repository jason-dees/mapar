//
//  MapNode.swift
//  MapAR
//
//  Created by Jason Dees on 6/2/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MapNode : SCNNode {
    
    var planeNode : SCNNode!
    public private(set) var hasRendered: Bool =  false
    public var image : UIImage = UIImage() {
        didSet {
            setPlaneImage(image: image)
        }
    }
    public var isMain : Bool = false {
        didSet{
            let color = isMain ? UIColor.red : UIColor.green
            if(!isMain){
                setPlaneNodeColor(color: color)
            }
        }
    };
    public var planeAnchor: ARPlaneAnchor!{
        didSet{
            setPosition(nextPlaneAnchor: planeAnchor)
        }
    }
    private func setup(){
        
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //        cityNode = scene.rootNode
        
        planeNode = SCNNode()
        planeNode.name = "plane"
        planeNode?.eulerAngles.x = -.pi / 2
        planeNode?.opacity = 1
        
        self.addChildNode(planeNode)
//        let constraint = SCNTransformConstraint(inWorldSpace: false, with:{
//            node, transformMatrix in
//
//            let width = self.nodeWidth(node: self.planeNode)
//            let height = self.nodeHeight(node: self.planeNode)
//            let cityWidth = self.nodeWidth(node: node)
//            let cityHeight = self.nodeHeight(node: node)
//            var scale = (width - 0.1)/cityWidth
//            if(width > height){
//                scale = (height - 0.1)/cityHeight
//            }
//            node.position = SCNVector3(x: self.planeNode.position.x,
//                                       y: cityHeight/2 * scale,
//                                       z: self.planeNode.position.z)
//            node.scale = SCNVector3(scale, scale, scale)
//            return node.transform
//        })
//        buildingNode.constraints = [constraint]
    }
    override init(){
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setPlaneImage(image: UIImage){
        planeNode?.geometry?.firstMaterial?.diffuse.contents = image
        (planeNode?.geometry as! SCNPlane).width = image.size.width;
        (planeNode?.geometry as! SCNPlane).height = image.size.height;
    }
    
    private func setPlaneNodeColor(color : UIColor){
        planeNode?.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    private func setPosition(nextPlaneAnchor: ARPlaneAnchor) {
        var extentX = nextPlaneAnchor.extent.x
        var extentZ = nextPlaneAnchor.extent.z
        
        let plane = SCNPlane(width: CGFloat(extentX), height: CGFloat(extentZ))
        
        planeNode?.geometry = plane
        let x = nextPlaneAnchor.center.x
        let y = nextPlaneAnchor.center.z
        planeNode?.simdPosition = float3(x: x, y: 0, z: y)
        
        hasRendered = true
    }
}
