//
//  SceneDelegate.swift
//  MapAR
//
//  Created by Jason Dees on 6/2/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MaprSceneDelegate : NSObject, ARSCNViewDelegate {

    var _isFirst : Bool = true;
    var _image : UIImage = UIImage(named: "default-map")! {
        didSet {
            if(planes.count > 0){
                displayedNode.image = self._image
            }
        }
    };
    
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
    
    public var showNewPlacements: Bool = false {
        didSet {
            if(showNewPlacements){
                self.showOtherPlanes()
            }
            else{
                self.hideOtherPlanes()
            }
        }
    }
    
    public private(set) var game : MaprGame!
    
    override init(){
        //Will probably want to do some observer pattern stuff with the MaprGame
        super.init()
        game = MaprGame()
        game.addMapImageLoadedObserver(self) {
            sceneDelegate, maprGame in
            print("Setting map image")
            self._image = maprGame.primaryMapImageData
        }
    }
    
    func changeGame(from gameCode:String, onFinished:@escaping (String)->() = {status in } ){
        self._image = UIImage(named: "default-map")!
        game.changeGame(from: gameCode, onFinished: onFinished)
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
            newNode.image = self._image
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
