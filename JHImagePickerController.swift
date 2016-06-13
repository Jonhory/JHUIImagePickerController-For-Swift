//
//  JHImagePickerController.swift
//
//
//  Created by jonhory on 16/6/11.
//  Copyright © 2016年 gz.cn. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
import PhotosUI
import MobileCoreServices

/** 获取相机权限成功*/
typealias cameraSuccess   = (imagePickerController:UIImagePickerController)  -> Void
/** 获取相机权限失败*/
typealias cameraFail      = ()                                               -> Void
/** 获取相簿权限成功*/
typealias albumSuccess    = (imagePickerController:UIImagePickerController)  -> Void
/** 获取相簿权限失败*/
typealias albumFail       = ()                                               ->Void

@objc protocol JHImagePickerControllerDelegate: class {
    /**
     获取图片回调
     
     - parameter image: 获取的图片
     
     - returns: 返回获取的图片
     */
    optional func selectImageFinished(image:UIImage)
    
    /**
     返回获取的图片并缓存(当设置缓存并且设置缓存标识符时返回该方法)
     - parameter image:            获取的图片
     - parameter cachesIdentifier: 缓存标识符（缓存文件时的名称）
     - parameter isCachesSuccess:  缓存图片是否成功
     
     - returns: 返回获取的图片并缓存
     */
    optional func selectImageFinishedAndCaches(image:UIImage,cachesIdentifier:String,isCachesSuccess:Bool)
    
}

class JHImagePickerController: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //publice
    /** 选取图片代理*/
    weak var delegate:JHImagePickerControllerDelegate?
    /** 是否缓存*/
    var isCaches:Bool?
    /** 缓存图片的标识符*/
    var identifier:String?
    
    //private
    /** 获取相机权限成功*/
    private var cameraSuccessClosure:cameraSuccess!
    /** 获取相机权限失败*/
    private var cameraFailClosure:cameraFail!
    /** 获取相簿权限成功*/
    private var albumSuccessClosure:albumSuccess!
    /** 获取相簿权限失败*/
    private var albumFailClosure:albumFail!
    /** UIImagePickerController*/
    private var imagePickerController:UIImagePickerController! = nil
    /** 选取的图片*/
    private var image:UIImage?
    
    deinit{
       print("dealloc : \(self)")
    }
    
    override init() {
        super.init()
        cameraReady()
        
    }
    
    init(isCaches:Bool,identifier:String){
        super.init()
        cameraReady()
        self.isCaches = isCaches
        self.identifier = identifier
    }
    
    //MARK:从相机拍摄图片
    func selectImageFromCameraSuccess(closure:cameraSuccess,Fail failClosure:cameraFail){
        cameraFailClosure = failClosure
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == .Restricted || authStatus == .Denied{
            if cameraFailClosure != nil {
                cameraFailClosure()
            }
            return
        }
        
        cameraSuccessClosure = closure
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePickerController!.sourceType = .Camera
            imagePickerController!.mediaTypes = [kUTTypeImage as String]
            imagePickerController!.cameraCaptureMode = .Photo
            if cameraSuccessClosure != nil {
                cameraSuccessClosure(imagePickerController: imagePickerController!)
            }
        }
        
    }
    
    //MARK:从相簿选取图片
    func selectImageFromAlbumSuccess(closure:albumSuccess,Fail failClosure:albumFail){
        albumFailClosure = failClosure
        let status = ALAssetsLibrary.authorizationStatus()
        if status == .Restricted || status == .Denied {
            if albumFailClosure != nil {
                albumFailClosure()
            }
            return
        }

        albumSuccessClosure = closure
        imagePickerController!.sourceType = .PhotoLibrary
        if albumSuccessClosure != nil {
            albumSuccessClosure(imagePickerController:imagePickerController!)
        }
    }
    
    //MARK:UIImagePickerControllerDelegate
    //选取图片完成
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType:String = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String{
            image = info[UIImagePickerControllerEditedImage] as? UIImage
            if self.isCaches == true && self.identifier != nil && self.identifier != ""{
                let cachesStatus = saveImageToCaches(image!, identifier: self.identifier!)
                self.delegate?.selectImageFinishedAndCaches?(image!,
                                           cachesIdentifier: self.identifier!,
                                            isCachesSuccess: cachesStatus)
            }else {
                self.delegate?.selectImageFinished?(image!)
            }
        }
    }
    
    //MARK:读取缓存的图片
    /**
     读取缓存的图片
     
     - parameter identifier: 图片标识符（缓存文件的名称）
     
     - returns: 读取缓存的图片
     */
    func readImageFromCaches(identifier:String) -> UIImage? {
        let path = jhSavePath + "/" + identifier
        var image:UIImage?
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            let read = NSFileHandle.init(forReadingAtPath: path)
            let data = read?.readDataToEndOfFile()
            image = UIImage.init(data: data!)
        }else {
            print("read image from caches fail , id:\(identifier)")
        }
        
        return image
    }
    
    /**
     删除指定缓存图片
     
     - parameter identifier: 缓存图片标识符（缓存图片名称）
     
     - returns: 删除指定缓存图片
     */
    func removeCachesPictureForIdentifier(identifier:String) -> Bool{
        let path = jhSavePath + "/" + identifier
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
                return true
            }catch {
                print("\(self) remove picture for id:\(identifier) failure")
                return false
            }
        }
        print("\(self) remove picture for id:\(identifier) failure ,error: path=\(path) isn't existed")
        return false
    }
    
    /**
     删除全部缓存图片
     
     - returns: 删除全部缓存图片
     */
    func removeCachesPictures() -> Bool {
        if NSFileManager.defaultManager().fileExistsAtPath(jhSavePath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(jhSavePath)
                return true
            }catch {
                print("\(self) remove pictures for path:\(jhSavePath) failure")
                return false
            }
        }
        print("\(self) remove pictures failure ,error: path=\(jhSavePath) isn't existed")
        return false
    }
    
    //MARK:Private
    private func cameraReady(){
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    //缓存图片
    private func saveImageToCaches(image:UIImage,identifier:String) -> Bool {
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        if (imageData != nil) {
            if  !NSFileManager.defaultManager().fileExistsAtPath(jhSavePath) {//如果不存在文件则创建
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(jhSavePath, withIntermediateDirectories: true, attributes: nil)
                    print("create file success:\(jhSavePath)")
                }catch{
                    print("create file failure")
                    return false
                }
            }
            let path = jhSavePath + "/" + identifier

            if NSFileManager.defaultManager().createFileAtPath(path, contents: imageData, attributes: nil){
                print("save pic for id:\(identifier) success")
                return true
            }
        }
        print("save pic failure")
        return false
    }
}


//MARK:缓存图片路径
let jhCachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
let jhSavePath = jhCachesPath + "/jhImageCaches"
