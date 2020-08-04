//
//  ItemCell.swift
//  FurnitAR
//
//  Created by Latif Atci on 7/29/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var objectNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
    }


}
