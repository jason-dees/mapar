//
//  ViewControllerSwiftUI.swift
//  MapAR
//
//  Created by Jason Dees on 3/1/20.
//  Copyright © 2020 Jason Dees. All rights reserved.
//

import SwiftUI



struct MapARView: View {
    var body: some View {
        MapARViewControllerWrapper(controllers: [MapARViewController()])
    }
}

struct MapARViewControllerWrapper: UIViewControllerRepresentable{
    var controllers: [MapARViewController]
    
    func makeUIViewController(context: Context) -> MapARViewController {
        let viewController = MapARViewController()
        return viewController
    }
    
    func updateUIViewController(_ viewController: MapARViewController, context: Context) {
    }
}

#if DEBUG
struct ViewControllerSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        MapARView()
    }
}
#endif
