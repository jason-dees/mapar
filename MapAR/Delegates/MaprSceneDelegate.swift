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

    var isFirst : Bool = true;
    //need to hold this for when planes are not yet found
    var image : UIImage = UIImage(named: "default-map")!
    
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
    
    public var areNewPlacementsHidden: Bool = true {
        didSet {
            self.toggleOtherPlanes(isHidden: self.areNewPlacementsHidden)
        }
    }
    
    public private(set) var gameManager : MaprGameManager!
    
    init(game: MaprGameManager = MaprGameManager()){
        self.gameManager = game
        super.init()
        game.addMapImageLoadedObserver(self) {[weak self]
            sceneDelegate, maprGameManager in
            if(self!.planes.count > 0){
                print("Setting map image")
                self!.image = maprGameManager.primaryMapImageData
                self!.displayedNode.image = maprGameManager.primaryMapImageData
                maprGameManager.markers.forEach({
                    let marker = self!.displayedNode.addMarker(marker:$0)
                    maprGameManager.loadMarkerImage($0, onFinished: {
                        markerImage in
                        marker.image = markerImage
                    })
                })
            } else {
                print("No nodes to set map image to")
                //How to set the markers after the game has been loaded and the image has been loaded?
            }
            //How do i want to get the image?
        }
    }
    
    func changeGame(from gameCode:String, onFinished:@escaping (String)->() = {status in } ){
        self.image = UIImage(named: "default-map")!
        gameManager.changeGame(from: gameCode, onFinished: onFinished)
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return SCNNode()}
        
        let node = MapNode(anchor: planeAnchor)
        node.isMain = isFirst
        if(isFirst){
            print("Found First Plane")
            node.isHidden = false;
            node.image = self.image
            isFirst = false;
        }
        else{
            print("Found \(planes.count + 1) Plane")
            node.isHidden = self.areNewPlacementsHidden
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
        for otherPlane in otherPlanes {
            otherPlane.isHidden = isHidden
        }
    }
}
