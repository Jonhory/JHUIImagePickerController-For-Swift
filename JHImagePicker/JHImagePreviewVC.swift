//
//  JHImagePreviewVC.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/17.
//
//

import UIKit

class JHImagePreviewVC: UIViewController, JHImagePreviewNavDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        loadUI()
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    var nav: JHImagePreviewNav!
    private func loadUI() {
        let f = CGRect(x: 0, y: 0, width: view.bounds.width, height: 64)
        nav = JHImagePreviewNav(frame: f)
        nav.delegate = self
        view.addSubview(nav)
    }

    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
