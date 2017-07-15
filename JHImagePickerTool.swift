//
//  JHImagePickerTool.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/13.
//
//

import Foundation
import UIKit
import Photos

let jhSCREEN = UIScreen.main.bounds.size

/// 校验相机权限
///
/// - Parameter status: 相册权限
/// - Returns: 是否有权限访问相册
func authorize(_ status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()) -> Bool {
    
    switch status {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (s) in
                DispatchQueue.main.async {
                    _ = authorize(s)
                }
            })
        default:
            return false
    }
    return false
}

// MARK: - 扩展
// MARK: - UIViewController
extension UIViewController {
    
    func jh_presentPhotoVC(_ maxCount: Int, completeHandler: ((_ assets: [PHAsset]) -> Void)? = nil) -> JHImageListController {
        let vc = JHImageListController()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barStyle = .black
        nav.navigationBar.backgroundColor = UIColor.black
        nav.navigationBar.tintColor = UIColor.white
        present(nav, animated: true)
        return vc
    }
    
}
