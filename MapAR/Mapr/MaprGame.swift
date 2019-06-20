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

    public private(set) var activeGameId : String = "-1"
    
    public private(set) var primaryMapImageData : UIImage = UIImage() {
        didSet{
            observations.mapImageLoaded.forEach { (key, closure) in
                closure(self)
            }
        }
    }
    
    private var game : Game{
        didSet {
            if(game.id == activeGameId){
                //Start loading everything else
                communicator.getMapImage(from: game.id, from: game.primaryMapId, completion: {data in
                    self.primaryMapImageData = UIImage(data: data) ?? UIImage()
                })
            }
        }
    }
    private var observations = (
        mapImageLoaded: [UUID : (MaprGame) -> Void](),
        mapMakersLoaded: [UUID : (MaprGame) -> Void]()
    )
    
    let communicator : MaprCommunicator

    init(communicator: MaprCommunicator = MaprCommunicator(from: "https://maprfunctions.azurewebsites.net/api")){
        self.communicator = communicator
        game = Game()
    }
    
    func changeGame(from gameId: String, onFinished:@escaping (String)->() = {status in } ){
        activeGameId = gameId
        communicator.getGameData(from: activeGameId,  completion: {data in
            let decoder = JSONDecoder()
            do{
                self.game = try decoder.decode(Game.self, from: data)
                onFinished("")
            }
            catch {
                onFinished(error.localizedDescription)
                return
            }
        })
    }
}
//https://www.swiftbysundell.com/posts/observers-in-swift-part-2
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
