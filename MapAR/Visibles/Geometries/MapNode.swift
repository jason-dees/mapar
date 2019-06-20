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
    //This is too tied to plane anchors and makes me sad
    var planeNode : SCNNode!
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
    public var isMain : Bool = false
    
    public var planeAnchor: ARPlaneAnchor!{
        didSet{
            setSize(planeAnchor: planeAnchor)
            setPosition(planeAnchor: planeAnchor)
        }
    }
    
    private var plane: SCNPlane {
        get {
            var plane = planeNode?.geometry as? SCNPlane
            if(plane == nil){
                plane = SCNPlane()
                planeNode?.geometry = plane
            }
            return plane!
        }
    }
    
    var _constraint: SCNTransformConstraint!
    
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
        
        self.setSize(width: extentX, height: extentZ)
        self.plane.firstMaterial?.diffuse.contents = image
    }
    
    func setPlaneNodeColor(color : UIColor){
        self.plane.firstMaterial?.diffuse.contents = color
        self.plane.firstMaterial?.transparency = CGFloat(0.5)
    }
    
    func setSize(planeAnchor: ARPlaneAnchor){
        let extentX = CGFloat(planeAnchor.extent.x)
        let extentZ = CGFloat(planeAnchor.extent.z)
        setSize(width: extentX, height: extentZ)
    }
    
    func setSize(width: CGFloat, height: CGFloat){
        self.plane.width = width
        self.plane.height = height
    }
    
    func setPosition(planeAnchor: ARPlaneAnchor) {
        let x = planeAnchor.center.x
        let y = planeAnchor.center.z
        setPosition(x: x, y: 0, z: y)
    }
    
    func setPosition(x: Float, y: Float, z: Float){
        setPosition(at: float3(x: x, y: y, z: y))
    }
    
    func setPosition(at: float3){
        planeNode?.simdPosition = at
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
