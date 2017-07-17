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
    
    var item: JHPhotoItem? {
        didSet {
            if item == nil { return }
            selectBtn.isSelected = item!.isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    private func loadUI() {
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.frame = CGRect(x: 0, y: 0, width: JHPhotosCellWH, height: JHPhotosCellWH)
        iv.backgroundColor = UIColor.lightGray
        contentView.addSubview(iv)
        
        let image = UIImage(named: "jh_select")
        let image2 = UIImage(named: "jh_selected")
        
        selectBtn.setImage(image, for: .normal)
        selectBtn.setImage(image2, for: .selected)
        
        selectBtn.frame = CGRect(x: JHPhotosCellWH - btnWH - 2, y: 2, width: btnWH, height: btnWH)
        selectBtn.addTarget(self, action: #selector(selectBtnClick(_:)), for: .touchUpInside)
        contentView.addSubview(selectBtn)
    }
    let btnWH: CGFloat = 27
    
    func selectBtnClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        item?.isSelected = btn.isSelected
        if btn.isSelected == true {
            btn.showAnimation()
        }
    }
    
    let iv = UIImageView()
    let selectBtn = UIButton(type: .custom)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
