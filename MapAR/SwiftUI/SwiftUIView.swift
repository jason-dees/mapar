//
//  SwiftUIView.swift
//  MapAR
//
//  Created by Jason Dees on 3/1/20.
//  Copyright © 2020 Jason Dees. All rights reserved.
//
import SwiftUI
import ARKit
import Combine
import RealityKit

struct SwiftUIView: View {
    var body: some View {
        return VStack{
                Text("Session Label")
            ARViewContainer(self)
                .edgesIgnoringSafeArea(.all)
            HStack{
                Button("Show Planes"){
                    print("Button 1")
                }.padding()
                Button("Enter Game"){
                    print("Button 1")
                }.padding()
            }
        }
    }
}

let arDelegate = SwiftUISessionDelegate()
let mapRDelegate = MaprSceneDelegate()
struct ARViewContainer<T: View>: UIViewRepresentable {
    var parent: T
    init(_ parent: T){
        self.parent = parent;
    }

    func makeUIView(context: Context) -> ARSCNView {

        let arView = ARSCNView(frame: .zero)

        arDelegate.set(arView: arView)
        arView.session.delegate = arDelegate
        arView.delegate = mapRDelegate
        
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}

final class SwiftUISessionDelegate: NSObject, ARSessionDelegate {
  var arView: ARSCNView!
  var rootAnchor: AnchorEntity?

  func set(arView: ARSCNView) {
    self.arView = arView
  }

  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {

    // If we already added the content to render, ignore
    if rootAnchor != nil {
       return
    }

    // Make sure we are adding to an image anchor. Assuming only
    // one image anchor in the scene for brevity.
    guard anchors[0] is ARImageAnchor else {
      return
    }

    // Create the entity to render, could load from your experience file here
    // this will render at the center of the matched image
    rootAnchor = AnchorEntity(world: [0,0,0])
    let ball = ModelEntity(
      mesh: MeshResource.generateBox(size: 0.01),
      materials: [SimpleMaterial(color: .red, isMetallic: false)]
    )
    rootAnchor!.addChild(ball)

    // Just add another model to show how it remains in the scene even
    // when the tracking image is out of view.
    let ball2 = ModelEntity(
      mesh: MeshResource.generateBox(size: 0.10),
      materials: [SimpleMaterial(color: .orange, isMetallic: false)]
    )
    ball.addChild(ball2)
    ball2.position = [0, 0, 1]
  }

  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    guard let rootAnchor = rootAnchor else {
      return
    }

    // Code is assuming you only have one image anchor for brevity
    guard let imageAnchor = anchors[0] as? ARImageAnchor else {
      return
    }

    if !imageAnchor.isTracked {
      return
    }

    // Update our fixed anchor to image transform
    rootAnchor.transform = Transform(matrix: imageAnchor.transform)
  }

}


#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
#endif
