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
            setPlaneImage(image: image, planeAnchor: planeAnchor)
        }
    }
    
    public var color: UIColor = .orange {
        didSet{
            setPlaneNodeColor(color : color)
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
    
    var _constraint: SCNTransformConstraint!
    
    private func setup(){
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //        cityNode = scene.rootNode
        
        planeNode = SCNNode()
        planeNode.name = "plane"
        planeNode?.eulerAngles.x = -.pi / 2
        planeNode?.opacity = 1
        buildConstraint()
        self.addChildNode(planeNode)
    }
    
    init(anchor:  ARPlaneAnchor){
        super.init()
        setup()
        planeAnchor = anchor
    }
    override init(){
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setPlaneImage(image: UIImage, planeAnchor: ARPlaneAnchor){
        var extentX = CGFloat(planeAnchor.extent.x)
        var extentZ = CGFloat(planeAnchor.extent.z)
        
        if(extentX > extentZ){
            //use plane width, adjust to image height
            let multiplier = image.size.width / extentX
            extentZ = image.size.height / multiplier;
        }
        else{
            // use plane height, adjust to image width
            let multiplier = image.size.height / extentZ
            extentX = image.size.width / multiplier;
        }
        
        let plane = SCNPlane(width: extentX, height: extentZ)
        
        plane.firstMaterial?.diffuse.contents = image
        planeNode?.geometry = plane
        
        hasRendered = true
    }
    
    func setPlaneNodeColor(color : UIColor){
        let extentX = CGFloat(planeAnchor.extent.x)
        let extentZ = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: extentX, height: extentZ)
        
        plane.firstMaterial?.diffuse.contents = image
        planeNode?.geometry = plane
        
        hasRendered = true
        planeNode?.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    private func setPosition(nextPlaneAnchor: ARPlaneAnchor) {
        let x = nextPlaneAnchor.center.x
        let y = nextPlaneAnchor.center.z
        planeNode?.simdPosition = float3(x: x, y: 0, z: y)
    }
    
    private func buildConstraint(){
        _constraint = SCNTransformConstraint(inWorldSpace: false, with:{
            node, transformMatrix in
            
            let width = MapNode.nodeWidth(node: self.planeNode)
            let height = MapNode.nodeHeight(node: self.planeNode)
            let cityWidth = MapNode.nodeWidth(node: node)
            let cityHeight = MapNode.nodeHeight(node: node)
            var scale = (width - 0.1)/cityWidth
            if(width > height){
                scale = (height - 0.1)/cityHeight
            }
            node.position = SCNVector3(x: self.planeNode.position.x,
                                       y: cityHeight/2 * scale,
                                       z: self.planeNode.position.z)
            node.scale = SCNVector3(scale, scale, scale)
            return node.transform
        })
    }
    
    private static func nodeWidth(node: SCNNode) -> Float{
        let boundingMax = node.boundingBox.max
        let boundingMin = node.boundingBox.min
        return boundingMax.x + abs(boundingMin.x)
    }
    
    private static func nodeHeight(node : SCNNode) -> Float{
        let boundingMax = node.boundingBox.max
        let boundingMin = node.boundingBox.min
        return boundingMax.y + abs(boundingMin.y)
    }
}
