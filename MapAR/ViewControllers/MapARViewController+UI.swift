//
//  ViewController+UI.swift
//  MapAR
//
//  Created by jdees on 6/20/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import UIKit
import ARKit

extension MapARViewController {
    func buildUI() {
        view.backgroundColor = UIColor.red        
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let sceneTapGesture = UITapGestureRecognizer(target: self, action: #selector(sceneTap))
        sceneTapGesture.delegate = self
        sceneView.addGestureRecognizer(sceneTapGesture)
        
        
        view.addSubview(sessionInfoView)
        sessionInfoView.translatesAutoresizingMaskIntoConstraints = false
        sessionInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sessionInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sessionInfoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sessionInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        sessionInfoView.addSubview(sessionInfoLabel)
        sessionInfoLabel.backgroundColor = UIColor.green
        sessionInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        sessionInfoLabel.leadingAnchor.constraint(equalTo: sessionInfoView.leadingAnchor).isActive = true
        sessionInfoLabel.trailingAnchor.constraint(equalTo: sessionInfoView.trailingAnchor).isActive = true
        if(sceneView.showsStatistics){
            sessionInfoLabel.bottomAnchor.constraint(equalTo: sessionInfoView.bottomAnchor, constant: -20).isActive = true
        }
        else{
            sessionInfoLabel.bottomAnchor.constraint(equalTo: sessionInfoView.bottomAnchor).isActive = true
        }
        
        view.addSubview(showHidePlanesButton)
        showHidePlanesButton.backgroundColor = UIColor.green
        showHidePlanesButton.translatesAutoresizingMaskIntoConstraints = false
        showHidePlanesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        showHidePlanesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        showHidePlanesButton.addTarget(self, action: #selector(showHideButtonTouchUp), for: .touchUpInside)
        
        view.addSubview(enterGameNameButton)
        enterGameNameButton.backgroundColor = UIColor.green
        enterGameNameButton.translatesAutoresizingMaskIntoConstraints = false
        enterGameNameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        enterGameNameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        enterGameNameButton.addTarget(self, action: #selector(showGameEntryBox), for: .touchUpInside)
    }
}
