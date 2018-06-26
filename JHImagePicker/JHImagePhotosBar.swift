//
//  JHImagePhotosBar.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/17.
//
//

import UIKit

enum JHImagePhotosBarType: Int {
    case preview = 256
    case finished
}

protocol JHImagePhotosBarDelegate: class {
    func barClicked(type: JHImagePhotosBarType)
}

class JHImagePhotosBar: UIView {
    
    weak var delegate: JHImagePhotosBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        backgroundColor = rgb(39, 46, 51)
    }
    
    @objc func btnC(_ btn: UIButton) {
        if let type = JHImagePhotosBarType(rawValue: btn.tag) {
            delegate?.barClicked(type: type)
        }
    }
    
    func handleBarBtn(enable: Bool, count: Int) {
        finishedBtn.isEnabled = enable
//        previewBtn.isEnabled = enable
        if finishedBtn.isEnabled {
            finishedBtn.backgroundColor = enableGreenColor
            finishedBtn.setTitle("完成(\(count))", for: .normal)
        } else {
            finishedBtn.backgroundColor = disableGreenColor
        }
    }
    
    private func loadUI() {
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.5))
        topLine.backgroundColor = UIColor.black
        let topLine2 = UIView(frame: CGRect(x: 0, y: 0.5, width: bounds.width, height: 0.5))
        topLine2.backgroundColor = rgb(35, 41, 46)
        
        addSubview(topLine)
        addSubview(topLine2)
        
        finishedBtn.frame = CGRect(x: bounds.width - 73, y: 6.5, width: 60, height: 31)
        finishedBtn.backgroundColor = disableGreenColor
        finishedBtn.setTitle("完成", for: .normal)
        finishedBtn.setTitle("完成", for: .disabled)
        finishedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        finishedBtn.layer.cornerRadius = 4
        finishedBtn.setTitleColor(rgb(93, 134, 92), for: .disabled)
        finishedBtn.setTitleColor(UIColor.white, for: .normal)
        finishedBtn.addTarget(self, action: #selector(btnC(_:)), for: .touchUpInside)
        finishedBtn.tag = JHImagePhotosBarType.finished.rawValue
        finishedBtn.isEnabled = false
        addSubview(finishedBtn)
        
//        previewBtn.frame = CGRect(x: 0, y: 0, width: 50, height: bounds.height)
//        previewBtn.setTitle("预览", for: .normal)
//        previewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        previewBtn.setTitleColor(rgb(93, 134, 92), for: .disabled)
//        previewBtn.setTitleColor(UIColor.white, for: .normal)
//        previewBtn.addTarget(self, action: #selector(btnC(_:)), for: .touchUpInside)
//        previewBtn.tag = JHImagePhotosBarType.preview.rawValue
//        previewBtn.isEnabled = false
//        addSubview(previewBtn)
    }
    
    let disableGreenColor = rgb(23, 82, 22)
    let enableGreenColor = rgb(26, 173, 25)
    let finishedBtn = UIButton(type: .custom)
//    let previewBtn = UIButton(type: .custom)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
