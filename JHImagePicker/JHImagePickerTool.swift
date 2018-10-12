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
let JHSCREEN_W = jhSCREEN.width
let JHSCREEN_H = jhSCREEN.height
let NOTI_jhPHAuthorized = Notification.Name(rawValue: "jhPHAuthorized")

func iPhoneX() -> Bool {
    return (JHSCREEN_W == 375.0 && JHSCREEN_H == 812.0)
}

/// 34 / 0
func TabbarSafeBottomMargin() -> CGFloat {
    return iPhoneX() ? 34.0 : 0.0
}

//MARK: - 常用方法
func rgb(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    return rgba(r, g, b, 1.0)
}

func rgbRandom() -> UIColor {
    return rgba(CGFloat(Int(arc4random()%255)), CGFloat(Int(arc4random()%255)), CGFloat(Int(arc4random()%255)), 1.0)
}

func rgba(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


/// 获取原图数据
///
/// - Parameters:
///   - asset: 图片资源
///   - finished: 图片回调
func getOriginalImage(_ asset: PHAsset, finished: @escaping ((_ originalImage: UIImage) -> Void )) {
    let manager = PHCachingImageManager()
    let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    
    manager.requestImage(for: asset, targetSize: size, contentMode: .default, options: options) { (image, dict) in
        if (image != nil) {
            finished(image!)
        }
    }
}

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
                    NotificationCenter.default.post(name: NOTI_jhPHAuthorized, object: nil)
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
    
    func jh_presentPhotoVC(_ maxCount: Int, completeHandler: @escaping JHImagePhotosCompletion) -> JHImageListVC {
        let vc = JHImageListVC()
        vc.listMaxCount = maxCount
        vc.myBlock = completeHandler
        
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barStyle = .black
        nav.navigationBar.tintColor = UIColor.white
        
        present(nav, animated: true)
        return vc
    }
    
}

// MARK: - UIView
extension UIView {
    func showAnimation(_ duration: TimeInterval = 0.6, _ maxScale: CGFloat = 1.1, _ minScale: CGFloat = 0.9) {
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration/3, animations: {
                self.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
            })
            UIView.addKeyframe(withRelativeStartTime: duration/3, relativeDuration: duration/3*2, animations: {
                self.transform = CGAffineTransform(scaleX: minScale, y: minScale)
            })
            UIView.addKeyframe(withRelativeStartTime: duration/3*2, relativeDuration: duration, animations: {
                self.transform = CGAffineTransform.identity
            })
        }, completion: nil)
        
    }
}

