//
//  ViewController.swift
//  FurnitAR
//
//  Created by Latif Atci on 7/27/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class FurnitARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    
    var objectVC: ObjectSelectionViewController?
    var selectedObject = "chair"
    var objectsArray = [SCNNode]()
    var objectNames = ["chair", "table", "shelf", "armchair"]
    var selectedObjects = IndexSet()
    let coachingOverlay = ARCoachingOverlayView()

    var selectedNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = .showFeaturePoints
        setupCoachingOverlay()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    @IBAction func removeObjects(_ sender: UIBarButtonItem) {
        for object in objectsArray {
            object.removeFromParentNode()
        }
    }
    
    @IBAction func addObjectTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showObjects", sender: addObjectButton)
    }
}

extension FurnitARViewController: ObjectSelectionViewControllerDelegate {
    
    func virtualObjectSelectionViewController(_ selectionViewController: ObjectSelectionViewController, didSelectObject: String, indexPath: IndexPath) {
        selectedObjects.insert(indexPath.row)
        
        selectedObject = didSelectObject
    }
    
    func virtualObjectSelectionViewController(_ selectionViewController: ObjectSelectionViewController, didDeselectObject: String, indexPath: IndexPath) {
        selectedObjects.remove(indexPath.row)
        print(didDeselectObject)
    }
}
