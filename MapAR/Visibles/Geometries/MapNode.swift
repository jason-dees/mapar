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
        planeNode = SCNNode()
        planeNode.name = "plane"
        planeNode?.eulerAngles.x = -.pi / 2
        planeNode?.opacity = 1
        self.addChildNode(planeNode)
        planeNode.constraints = [self.buildPlaneConstraint()]
    }
    
    private func setPlaneImage(image: UIImage, planeAnchor: ARPlaneAnchor){
//        var extentX = CGFloat(planeAnchor.extent.x)
//        var extentZ = CGFloat(planeAnchor.extent.z)
//
//        if(extentX > extentZ){
//            //use plane width, adjust to image height
//            let multiplier = image.size.width / extentX
//            extentZ = image.size.height / multiplier;
//        }
//        else{
//            // use plane height, adjust to image width
//            let multiplier = image.size.height / extentZ
//            extentX = image.size.width / multiplier;
//        }
//
//        self.setSize(width: extentX, height: extentZ)
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
    
    func addMarker(marker: MapMarker){
        let markerNode = MarkerNode(markerId: marker.id)
        markerNode.constraints = [self.buildMarkerConstraint(marker: marker)]
        self.addChildNode(markerNode)
    }
    
    private func buildMarkerConstraint(marker: MapMarker) -> SCNTransformConstraint {
        //so instead of doing this, i write a constraint for the planeNode
        return SCNTransformConstraint(inWorldSpace: false, with:{
            node, transformMatrix in
            let width = self.image.size.width
            let mapWidth = self.plane.width
            var scale = width/mapWidth
            if(width > mapWidth){
                scale = mapWidth/width
            }
            let newX = Float(marker.x) * Float(scale)
            let newY = Float(marker.y) * Float(scale)
            node.position = SCNVector3(x: newX,
                                       y: 0,
                                       z: newY)
            node.scale = SCNVector3(scale, scale, scale)
            return node.transform
        })
    }
    
    private func buildPlaneConstraint() ->SCNTransformConstraint{
        return SCNTransformConstraint(inWorldSpace: false, with:{
            node, transformMatrix in
            if(self.planeAnchor != nil){
                let extentX = CGFloat(self.planeAnchor.extent.x)
                let extentZ = CGFloat(self.planeAnchor.extent.z)
                let xScale = extentX > self.image.size.width ? self.image.size.width / extentX : extentX / self.image.size.width
                let zScale = extentZ > self.image.size.height ? self.image.size.height / extentZ : extentZ / self.image.size.height
                node.scale = SCNVector3(xScale, 1, zScale)
            }

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
