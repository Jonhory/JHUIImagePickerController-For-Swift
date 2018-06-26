//
//  JHImagePreviewNav.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/17.
//
//

import UIKit

protocol JHImagePreviewNavDelegate: class {
    func back()
}

class JHImagePreviewNav: UIView {
    
    weak var delegate: JHImagePreviewNavDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        backgroundColor = rgb(33, 33, 33)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    @objc func backC() {
        delegate?.back()
    }
    
    private func loadUI() {
        let backWH: CGFloat = 19
        backBtn.frame = CGRect(x: 10.0, y: (bounds.height - backWH) / 2, width: backWH, height: backWH)
        let image = UIImage(named: "jh_back")
        backBtn.setImage(image, for: .normal)
        backBtn.addTarget(self, action: #selector(backC), for: .touchUpInside)
        addSubview(backBtn)
        
        let selectWH: CGFloat = 30
        selectBtn.frame = CGRect(x: bounds.width - selectWH - 14, y: (bounds.height - selectWH)/2, width: selectWH, height: selectWH)
        let image2 = UIImage(named: "jh_select")
        selectBtn.setBackgroundImage(image2, for: .normal)
        addSubview(selectBtn)
        
    }
    
    let backBtn = UIButton(type: .custom)
    let selectBtn = UIButton(type: .custom)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
