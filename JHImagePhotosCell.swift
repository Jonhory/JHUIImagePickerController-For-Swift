//
//  JHImagePhotosCell.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/15.
//
//

import UIKit

let JHPhotosCellWH: CGFloat = (jhSCREEN.width - 5 * 4) / 4

let JHImagePhotosCellID = "JHImagePhotosCellID"

class JHImagePhotosCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    
    private func loadUI() {
        contentView.addSubview(iv)
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.frame = CGRect(x: 0, y: 0, width: JHPhotosCellWH, height: JHPhotosCellWH)
        iv.backgroundColor = UIColor.lightGray
    }
    
    let iv = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
