//
//  JHImagePreviewCell.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/10/21.
//

import UIKit

let JHImagePreviewCellID = "JHImagePreviewCellID"

class JHImagePreviewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        loadUI()
    }
    
    private func loadUI() {
        backgroundColor = rgbRandom()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
