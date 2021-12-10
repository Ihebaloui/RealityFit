
//
//  ArViewController.swift
//  RealityFit
//
//  Created by Apple Esprit on 20/11/2021.
//

import UIKit
import RealityKit
import ARKit

class ArViewController: UIViewController, ARSessionDelegate {

    
 /*   @IBOutlet weak var arView: ARView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
     setupARView()
        
    arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    // Setup methods
   func setupARView() {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
    }
    
    
    // Object Placement
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        let location = recognizer.location(in: arView)
        
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first{
            let anchor = ARAnchor(name: "reactshoe", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
        } else {
            print("Object placement failed - could'nt find surface")
        }
    }
    
    
       func placeObject(named entityName: String, for anchor: ARAnchor){
        let entity = try! ModelEntity.loadModel(named: entityName)
        
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: entity)
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity)
        arView.scene.addAnchor(anchorEntity)
        
    }
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "reactshoe"{
                placeObject(named: anchorName, for: anchor)
                
            }
        }
    }
*/
}

