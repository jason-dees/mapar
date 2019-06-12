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
    
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadMapData(){
        let mapUrl = URL(string: "https://maprfunctions.azurewebsites.net/api/games/\(self.activeGameId)/activemap/image")!
        downloadImage(from: mapUrl)
        let markerUrl = URL(string: "https://maprfunctions.azurewebsites.net/api/games/\(self.activeGameId)/activemap/markers")!
        downloadMarkerData(from: markerUrl)
    }
    
    private func downloadImage(from url: URL){
        MaprGame.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                self.primaryMapImageData = UIImage(data: data)!
            }
        }
    }
    
    private func downloadMarkerData(from url: URL){
        MaprGame.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                var json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            }
        }
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
