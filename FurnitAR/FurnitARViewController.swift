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
    
    var selectedNode: SCNNode? {
        didSet {
            print("new object selected")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = .showFeaturePoints
        
        addGestureRecognizers()
        
        
    }
    @IBAction func addObjectTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showObjects", sender: addObjectButton)
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

//MARK: GestureRecognizers
extension FurnitARViewController {
    
    func addItem(hitTestResult: ARHitTestResult) {
        let objectScene = SCNScene(named: "art.scnassets/\(selectedObject).scn")
        
        if let objectNode = objectScene?.rootNode.childNode(withName: "\(selectedObject)", recursively: true) {
            
            objectNode.position = SCNVector3(x: hitTestResult.worldTransform.columns.3.x, y: hitTestResult.worldTransform.columns.3.y, z: hitTestResult.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(objectNode)
            objectsArray.append(objectNode)
        }
    }
    
    fileprivate func addGestureRecognizers() {
        let longPressGeastureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectNode))
        sceneView.addGestureRecognizer(longPressGeastureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let pinchGeastureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        sceneView.addGestureRecognizer(pinchGeastureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGestureRecognizer.maximumNumberOfTouches = 1
        sceneView.addGestureRecognizer(panGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        sceneView.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            guard let selectedNode = selectedNode else { return }
            let sceneView = sender.view as! ARSCNView
            let panLocation = sender.location(in: sceneView)
            let hitTest = sceneView.hitTest(panLocation, types: .existingPlaneUsingGeometry)
            
            if !hitTest.isEmpty {
                let result = hitTest.first!
                let thirdColumn = result.worldTransform.columns.3
                let position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
                selectedNode.worldPosition = position
            }
        }
    }
    
    @objc func selectNode(sender: UILongPressGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let holdLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(holdLocation)
        
        if !hitTest.isEmpty {
            let result = hitTest.first!
            if sender.state == .began {
                selectedNode = result.node
            } else if sender.state == .ended {
                print("LongPressEnded")
            }
        }
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            addItem(hitTestResult: hitTest.first!)
            
        } else {
            return
        }
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(pinchLocation)
        if !hitTest.isEmpty {
            let results = hitTest.first!
            let node = results.node

            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            node.runAction(pinchAction)

            sender.scale = 1.0
        }
    }
    
    @objc func rotate(sender: UIRotationGestureRecognizer) {
        guard let selectedNode = selectedNode else { return }
        if sender.state == .changed {
            if sender.rotation < 0 { // clockwise
                let rotationAcrion = SCNAction.rotate(by: sender.rotation * 0.15, around: SCNVector3(0, selectedNode.position.y, 0), duration: 0)
                selectedNode.runAction(rotationAcrion)
            } else { // counterclockwise
                let rotationAcrion = SCNAction.rotate(by: sender.rotation * 0.15, around: SCNVector3(0, selectedNode.position.y, 0), duration: 0)
                selectedNode.runAction(rotationAcrion)
            }
        }
    }
}

extension FurnitARViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }

        let objectSelectionVC = segue.destination as! ObjectSelectionViewController
        objectVC = objectSelectionVC
        objectVC?.selectedObjects = selectedObjects
        objectVC?.delegate = self
    }
    
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        objectVC = nil
    }
}
