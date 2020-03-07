//
//  MaprGame.swift
//  MapAR
//
//  Created by jdees on 6/11/19.
//  Copyright © 2019 Jason Dees. All rights reserved.
//

import Foundation
import ARKit

class MaprGameManager {

    public private(set) var activeGameId : String = "-1"
    
    public private(set) var primaryMapImageData : UIImage = UIImage() {
        didSet{
            observations.mapImageLoaded.forEach { (key, closure) in
                closure(self)
            }
        }
    }
    
    public var markers : [MapMarker] {
        get {
            return self.game.maps.first(where: {$0.isPrimary})?.markers ?? []
        }
    }
    
    private var game : Game{
        didSet {
            if(game.id == activeGameId){
                //Start loading everything else
            }
        }
    }
    private var observations = (
        mapImageLoaded: [UUID : (MaprGameManager) -> Void](),
        mapMakersLoaded: [UUID : (MaprGameManager) -> Void]()
    )
    
    let communicator : MaprCommunicator

    init(communicator: MaprCommunicator = MaprCommunicator(from: "https://maprfunctions.azurewebsites.net/api")){
        self.communicator = communicator
        game = Game()
    }
    
    func changeGame(from gameId: String, onFinished:@escaping (String)->() = {status in } ){
        activeGameId = gameId
        communicator.getGameData(from: activeGameId,  completion: {[weak self] data in
            let decoder = JSONDecoder()
            do{
                self!.game = try decoder.decode(Game.self, from: data)
                
                self!.communicator.getMapImage(from: self!.game.id, from: self!.game.primaryMapId,
                                               completion: {[weak self] data in
                                                self!.primaryMapImageData = UIImage(data: data) ?? UIImage()
                                                onFinished("")
                })
            }
            catch {
                onFinished(error.localizedDescription)
                return
            }
        })
    }
    
    func loadMarkerImage(_ marker: MapMarker, onFinished: @escaping (UIImage) -> ()){
        self.communicator.getMarkerImage(forGame: marker.gameId, forMap: marker.mapId, forMarker: marker.id) { imageData in
            onFinished(UIImage(data: imageData) ?? UIImage())
        }
    }
}

//https://www.swiftbysundell.com/posts/observers-in-swift-part-2
extension MaprGameManager {
    @discardableResult
    func addMapImageLoadedObserver<T: AnyObject>(observer: T, closure: @escaping (T, MaprGameManager) -> Void) -> ObservationToken {
        let id = UUID()
        //Setting weak refernences to keep this closure from
        //causing a strong reference cycle with self and the closure
        observations.mapImageLoaded[id] = { [weak self, weak observer] gameManager in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.mapImageLoaded.removeValue(forKey: id)
                return
            }
            
            closure(observer, gameManager)
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
