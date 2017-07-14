//
//  JHImageListController.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/13.
//
//

import UIKit

class JHImageListController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setRightBtn()
        
        let isEnablePhoto = authorize()
        if isEnablePhoto {
            print("我可是有权限哦")
            title = "相册"
        } else {
            showUnablePhoto()
        }
    }
    
    func cancelClicked() {
        dismiss(animated: true)
    }
    
    private func setRightBtn() {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 34, height: 20.5)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.white, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }

    private func showUnablePhoto() {
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = "请在iPhone的“设置-隐私-照片”选项中，允许本应用访问你的手机相册。"
        label.frame = CGRect(x: 60, y: 120, width: SCREEN.width - 120, height: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        view.addSubview(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
