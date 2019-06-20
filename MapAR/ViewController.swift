//
//  ViewController.swift
//  MapAR
//
//  Created by Jason Dees on 6/2/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    private let sceneView: ARSCNView = {
        let arview = ARSCNView();
        return arview;
    }()
    
    private let sessionInfoView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    }()
    
    private let sessionInfoLabel: UILabel = {
        let uiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        uiLabel.text = "this is some text"
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    private let showHidePlanesButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        button.setTitle("Show Planes", for: .normal)
        return button
    }()
    
    private let enterGameNameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        button.setTitle("Enter Game", for: .normal)
        return button
    }()
    
    var sceneDelegate : MaprSceneDelegate!
    var sessionDelegate : SessionDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        // Create a new scene
        sceneDelegate = MaprSceneDelegate()
        sessionDelegate = SessionDelegate(label: sessionInfoLabel, view: sessionInfoView)
        sceneView.delegate = sceneDelegate
        sceneView.session.delegate = sessionDelegate
        //sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal, .vertical]
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @objc func showHideButtonTouchUp(_ sender: Any) {
        sceneDelegate.showNewPlacements = !sceneDelegate.showNewPlacements
        
        let titleString = sceneDelegate.showNewPlacements ? "Hide Planes" : "Show Planes"
        showHidePlanesButton.setTitle(titleString, for: .normal)
        
    }
    
    @objc func showGameEntryBox(_ sender: Any){
        let alert = UIAlertController(title: "Enter Game Code",
                                      message: "Please input the alphanumeric gamecode",
                                      
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Game code"
            textField.text = "KR0ACE"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (alertAction) in }
        let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            
            
            let loadingAlert = UIAlertController(title: nil, message: "Loading Game Data...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            loadingAlert.view.addSubview(loadingIndicator)
            self.present(loadingAlert, animated: true, completion: nil)
            
            self.sceneDelegate.changeGame(from: (alert.textFields![0] as UITextField).text ?? "", onFinished: {
                status in
                self.dismiss(animated: false, completion: nil)
                if status == "" { return }
                
            })
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    @objc func screenZoom(_ sender: Any){
        
    }
    
    private func buildUI() {
        view.backgroundColor = UIColor.red
        
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        sessionInfoLabel.bottomAnchor.constraint(equalTo: sessionInfoView.bottomAnchor, constant: -20).isActive = true
        
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
