//
//  WeatherNode.swift
//  MapAR
//
//  Created by jdees on 6/24/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class WeatherNode : SCNNode {
    
    //I need sun, rain, storm, snow effects?
    override init(){
        super.init()
        self.castsShadow = true
        self.light = SCNLight()
        self.light?.type = .omni
        self.light?.color = UIColor.white
        self.light?.intensity = 1000
        self.position = SCNVector3(0,1,1)
        
        //let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(changeWeather), userInfo: nil, repeats: true)
        
        //RunLoop.current.add(timer, forMode: .common)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func changeWeather(){
        func random() -> CGFloat { return .random(in:0...1) }
        
        self.light?.color = UIColor(red:   random(),
                       green: random(),
                       blue:  random(),
                       alpha: 1.0)
    }

}
