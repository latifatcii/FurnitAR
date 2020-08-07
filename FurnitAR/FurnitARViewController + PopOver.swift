//
//  FurnitARViewController + PopOver.swift
//  FurnitAR
//
//  Created by Latif Atci on 8/6/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

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
