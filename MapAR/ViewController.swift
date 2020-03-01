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
    
    let sceneView: ARSCNView = {
        let arview = ARSCNView();
        return arview;
    }()
    
    let sessionInfoView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    }()
    
    let sessionInfoLabel: UILabel = {
        let uiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        uiLabel.text = "this is some text"
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    let showHidePlanesButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        button.setTitle("Show Planes", for: .normal)
        return button
    }()
    
    let enterGameNameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        button.setTitle("Enter Game", for: .normal)
        return button
    }()
    
    var sceneDelegate : MaprSceneDelegate!
    var sessionDelegate : SessionDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a new scene
        sceneDelegate = MaprSceneDelegate()
        sessionDelegate = SessionDelegate(label: sessionInfoLabel, view: sessionInfoView)
        sceneView.delegate = sceneDelegate
        sceneView.session.delegate = sessionDelegate
        //sceneView.showsStatistics = true
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]        // Run the view's session
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
        sceneDelegate.areNewPlacementsHidden = !sceneDelegate.areNewPlacementsHidden
        
        let titleString = sceneDelegate.areNewPlacementsHidden ? "Show Planes" : "Hide Planes"
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
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
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
    
  
}
