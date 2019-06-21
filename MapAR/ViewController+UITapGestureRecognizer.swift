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
//        guard let arView = recognizer.view as? ARSCNView else { return }
//        
//        let tapScreenLocation = recognizer.location(in: arView)
//        let bottomRight = CGPoint(x: arView.frame.maxX, y: arView.frame.maxY)
//        let tapLocation = CGPoint(x: tapScreenLocation.x/bottomRight.x, y: tapScreenLocation.y/bottomRight.y)
//        //I don't think i want hit tests soooo...
//        let results = arView.hitTest(tapLocation, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane, .estimatedVerticalPlane])
//        if(results.count>0){
//            let first = results.first
//        }
    }
}
