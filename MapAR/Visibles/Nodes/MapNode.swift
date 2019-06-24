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
    
    public var color: UIColor {
        get{
            return self.mapPlane.color
        }
        set(newColor) {
            self.mapPlane.color = newColor
        }
    }
    public var image : UIImage {
        get {
            return self.mapPlane.image
        }
        set(newImage) {
            self.mapPlane.image = newImage
        }
    }
    public var isMain : Bool = false
    
    public var planeAnchor: ARPlaneAnchor! {
        didSet{
            setSize(planeAnchor: planeAnchor)
            setPosition(planeAnchor: planeAnchor)
        }
    }
    
    private var mapPlane: MapPlane!
    
    init(anchor:  ARPlaneAnchor){
        planeAnchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        self.planeNode = SCNNode()
        self.planeNode.name = "plane"
        self.planeNode.eulerAngles.x = -.pi / 2
        self.planeNode.opacity = 1
        self.addChildNode(planeNode)
        self.planeNode.constraints = [self.buildPlaneConstraint()]
        self.mapPlane = MapPlane()
        self.planeNode.geometry = self.mapPlane
        
        let weatherNode = WeatherNode()
        weatherNode.name = "weather"
        weatherNode.eulerAngles.x = -.pi / 2
        weatherNode.opacity = 1
        self.addChildNode(weatherNode)
    }
    
    private func updateAspecRatio(){
        var extentX = CGFloat(self.planeAnchor.extent.x)
        var extentZ = CGFloat(self.planeAnchor.extent.z)

        if(extentX > extentZ){
            //use plane width, adjust to image height
            let multiplier = self.image.size.width / extentX
            extentZ = self.image.size.height / multiplier;
        }
        else{
            // use plane height, adjust to image width
            let multiplier = self.image.size.height / extentZ
            extentX = self.image.size.width / multiplier;
        }

        self.setSize(width: extentX, height: extentZ)
    }
    
    func setSize(planeAnchor: ARPlaneAnchor){
        let extentX = CGFloat(planeAnchor.extent.x)
        let extentZ = CGFloat(planeAnchor.extent.z)
        setSize(width: extentX, height: extentZ)
    }
    
    func setSize(width: CGFloat, height: CGFloat){
        self.mapPlane.setSize(width: width, height: height)
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
    
    func addMarker(marker: MapMarker) -> MarkerNode{
        let markerNode = MarkerNode(newMarkerId: marker.id)
        markerNode.constraints = [self.buildMarkerConstraint(marker: marker)]
        self.addChildNode(markerNode)
        return  markerNode
    }
    
    private func buildMarkerConstraint(marker: MapMarker) -> SCNTransformConstraint {
        return SCNTransformConstraint(inWorldSpace: false, with:{
            node, transformMatrix in
            
            let imageWidth = self.mapPlane.image.size.width
            let planeWidth = self.mapPlane.width
            var scale = imageWidth/planeWidth
            if(imageWidth > planeWidth){
                scale = planeWidth/imageWidth
            }
            
            let newX = Float(marker.x) * Float(scale) - Float(self.mapPlane.width)/2
            let newY = Float(marker.y) * Float(scale) - Float(self.mapPlane.height)/2
            //position from 0,0,0 ugh oh my god
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
            
            self.updateAspecRatio()
            return node.transform
        })
    }
}
