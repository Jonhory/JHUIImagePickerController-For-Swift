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

protocol JHImagePhotosCellDelegate: class {
    func photsCellClicked(withItem: JHPhotoItem, btn: UIButton)
}

class JHImagePhotosCell: UICollectionViewCell {
    
    weak var delegate: JHImagePhotosCellDelegate?
    
    var item: JHPhotoItem? {
        didSet {
            if item == nil { return }
            selectBtn.isSelected = item!.isSelected
            selectBtn.setTitle("\(item!.index)", for: .selected)
            maskV.isHidden = item!.isAble
            if item!.isNeedAnimated {
                selectBtn.showAnimation()
                item!.isNeedAnimated = false
            }
        }
    }
    
    @objc func selectBtnClick(_ btn: UIButton) {
        if item != nil {
            delegate?.photsCellClicked(withItem: item!, btn: btn)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    let btnWH: CGFloat = 27
    let iv = UIImageView()
    let selectBtn = UIButton(type: .custom)
    let maskV = UIButton(type: .custom)
    
    private func loadUI() {
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.frame = CGRect(x: 0, y: 0, width: JHPhotosCellWH, height: JHPhotosCellWH)
        iv.backgroundColor = UIColor.lightGray
        contentView.addSubview(iv)
        
        maskV.frame = iv.frame
        maskV.backgroundColor = UIColor.white
        maskV.alpha = 0.5
        maskV.isHidden = true
        contentView.addSubview(maskV)
        
        let image = UIImage(named: "jh_select")
        let image2 = UIImage(named: "jh_selected")
        
        selectBtn.setBackgroundImage(image, for: .normal)
        selectBtn.setBackgroundImage(image, for: .highlighted)
        selectBtn.setBackgroundImage(image2, for: .selected)
        selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        selectBtn.frame = CGRect(x: JHPhotosCellWH - btnWH - 2, y: 2, width: btnWH, height: btnWH)
        selectBtn.addTarget(self, action: #selector(selectBtnClick(_:)), for: .touchUpInside)
        contentView.addSubview(selectBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
