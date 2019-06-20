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
    
    public var hideNewPlacements: Bool = true {
        didSet {
            self.toggleOtherPlanes(isHidden: self.hideNewPlacements)
        }
    }
    
    public private(set) var gameManager : MaprGameManager!
    
    init(game: MaprGameManager = MaprGameManager()){
        self.gameManager = game
        super.init()
        game.addMapImageLoadedObserver(self) {
            sceneDelegate, maprGameManager in
            print("Setting map image")
            self._image = maprGameManager.primaryMapImageData
            maprGameManager.markers.forEach({ self.displayedNode.addMarker(marker:$0) })
        }
    }
    
    func changeGame(from gameCode:String, onFinished:@escaping (String)->() = {status in } ){
        self._image = UIImage(named: "default-map")!
        gameManager.changeGame(from: gameCode, onFinished: onFinished)
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return SCNNode()}
        
        let node = MapNode(anchor: planeAnchor)
        node.isMain = _isFirst
        if(_isFirst){
            node.isHidden = false;
            node.image = self._image
            _isFirst = false;
        }
        else{
            node.isHidden = self.hideNewPlacements
            node.color = .orange
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let mapNode = node as? MapNode else { return }
        
        planes.append(mapNode)
    }
    
    /// - Tag: UpdateARContent
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
    }
    
    func toggleOtherPlanes(isHidden: Bool){
        for otherPlane in otherPlanes{
            otherPlane.isHidden = isHidden
        }
    }
}
