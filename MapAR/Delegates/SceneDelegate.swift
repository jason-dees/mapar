//
//  SceneDelegate.swift
//  MapAR
//
//  Created by Jason Dees on 6/2/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class SceneDelegate : NSObject, ARSCNViewDelegate {
    
    var _showNewPlacements : Bool = false
    var _isFirst : Bool = true;
    
    var planes : Array<MapNode> = Array()
    var displayedNode : MapNode {
        get {
            return planes.first(where:{ $0.isMain })!
        }
    }
    
    var otherPlanes : Array<MapNode> {
        get {
            return planes.filter({ !$0.isMain })
        }
    }
    
    public var showNewPlacements: Bool {
        get {
            return _showNewPlacements
        }
        set(newShowNewPlacements) {
            _showNewPlacements = newShowNewPlacements
            if(_showNewPlacements){
                self.showOtherPlanes()
            }
            else{
                self.hideOtherPlanes()
            }
        }
    }
    
    override init(){
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        
        let newNode = MapNode()
        newNode.planeAnchor = planeAnchor
        newNode.isMain = _isFirst
        if(_isFirst){
            newNode.isHidden = false;
            _isFirst = false;
        }
        else{
            newNode.isHidden = !showNewPlacements
        }
        node.addChildNode(newNode)
        planes.append(newNode)
    }
    
    /// - Tag: UpdateARContent
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
    }
    
    func hideOtherPlanes(){
        for otherPlane in otherPlanes{
            otherPlane.isHidden = true
        }
    }
    
    func showOtherPlanes(){
        for otherPlane in otherPlanes.filter({ !$0.hasRendered }) {
            otherPlane.isHidden = false
        }
    }
}
