//
//  ViewController.swift
//  EaseImagePickerController
//
//  Created by jonhory on 16/6/12.
//
//

import UIKit
import Photos

class ViewController: UIViewController,JHImagePickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = SelectViewController()
        present(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

