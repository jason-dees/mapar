//
//  MaprGame.swift
//  MapAR
//
//  Created by jdees on 6/11/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MaprGame {

    public private(set) var activeGameId : String
    public private(set) var primaryMapImageData : UIImage = UIImage() {
        didSet{
            observations.mapImageLoaded.forEach { (key, closure) in
                closure(self)
            }
        }
    }
    
    private var activeMaps : Set<String>
    private var observations = (
        mapImageLoaded: [UUID : (MaprGame) -> Void](),
        mapMakersLoaded: [UUID : (MaprGame) -> Void]()
    )
    
    let communicator : MaprCommunicator

    init(from gameId: String){
        communicator = MaprCommunicator(from: "https://maprfunctions.azurewebsites.net")
        activeMaps = []
        activeGameId = gameId
    }
    
    func changeGame(from gameId: String){
    
    }
}

extension MaprGame {
    @discardableResult
    func addMapImageLoadedObserver<T: AnyObject>(_ observer: T, closure: @escaping (T, MaprGame) -> Void) -> ObservationToken {
        let id = UUID()
        
        observations.mapImageLoaded[id] = { [weak self, weak observer] game in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.mapImageLoaded.removeValue(forKey: id)
                return
            }
            
            closure(observer, game)
        }
        
        return ObservationToken { [weak self] in
            self?.observations.mapImageLoaded.removeValue(forKey: id)
        }
    }
}

class ObservationToken {
    private let cancellationClosure: () -> Void
    
    init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }
    
    func cancel() {
        cancellationClosure()
    }
}
