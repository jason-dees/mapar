//
//  ViewController+UITapGestureRecognizer.swift
//  MapAR
//
//  Created by jdees on 6/20/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import UIKit
import ARKit

extension ViewController: UIGestureRecognizerDelegate {
    /// Determines if the tap gesture for presenting the `VirtualObjectSelectionViewController` should be used.
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func sceneTap(recognizer : UITapGestureRecognizer){
        guard let arView = recognizer.view as? ARSCNView else { return }
//        
        let tapScreenLocation = recognizer.location(in: arView)
        guard let node = arView.hitTest(tapScreenLocation).first?.node else { return }
        if(node is MarkerNode){
            // I need to do something with this node
            showMarkerAlert(marker: (node as! MarkerNode).markerData!)
        }
    }
    
    func showMarkerAlert(marker: MapMarker){
        let alert = UIAlertController(title: marker.name,
                                      message: marker.description ?? "[No Description]",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel){ (alertAction) in }
        
        alert.addAction(action)
        
        self.present(alert, animated:true, completion: nil)
    }
}
