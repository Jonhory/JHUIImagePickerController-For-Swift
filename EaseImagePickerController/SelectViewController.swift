//
//  SelectViewController.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/13.
//
//

import UIKit


class SelectViewController: UIViewController, JHImagePickerDelegate {

    var imagePicker:JHImagePicker?
    
    var imageView:UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.yellow
        //初始化方法一
        //        imagePicker = JHImagePicker()
        //初始化方法一的补充设置
        //设置是否缓存(默认为false)
        //        imagePicker?.isCaches = true
        //设置缓存id（当需要缓存时才设置）
        //        imagePicker?.identifier = "xx"
        
        //初始化方法二
        imagePicker = JHImagePicker(isCaches: true, identifier: "abc")
        //设置选择图片后回调的代理协议
        imagePicker?.delegate = self
        //设置是否使用裁剪模式,默认为true
        //        imagePicker?.isEditImage = false
        
        imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: jhSCREEN.width - 20, height: jhSCREEN.height - 280))
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        creatBtnWithTitle("选取图片", centerY: jhSCREEN.height - 50, action: #selector(selectImageClicked))
        
        creatBtnWithTitle("读取图片", centerY: jhSCREEN.height - 100, action: #selector(readImageClicked))
        
        creatBtnWithTitle("删除全部缓存", centerY: jhSCREEN.height - 150, action: #selector(deleteImageClicked))
        
        //        getAllPictures()
    }
    
    func creatBtnWithTitle(_ title:String,centerY y:CGFloat,action:Selector) {
        let button = UIButton(frame: CGRect(x: 0,y: 0,width: 200,height: 40))
        button.center = CGPoint(x: jhSCREEN.width/2, y: y);
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setTitle(title, for: UIControlState())
        self.view.addSubview(button)
    }
    
    //选取图片
    func selectImageClicked() {
        let alert = UIAlertController(title: "", message: "Choose the photo you like", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "From camera roll", style: .default) { (action) in
            //图片来自相机闭包 注意使用[weak self] 防止强引用
            self.imagePicker?.selectImageFromCameraSuccess({[weak self](imagePickerController) in
                if let strongSelf = self {
                    strongSelf.present(imagePickerController, animated: true, completion: nil)
                }
                }, Fail: {
                    //SVProgressHUD.showErrorWithStatus("无法获取相机权限")
            })
        }
        let photoAction = UIAlertAction(title: "Pictures", style: .default) { (action) in
            _ = self.jh_presentPhotoVC(1, completeHandler: { items in
                print("当前选中的图片数组", items)
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //根据identifier读取缓存图片
    func readImageClicked() {
        let image = self.imagePicker?.readImageFromCaches("abc")
        imageView.image = image
    }
    
    func deleteImageClicked(){
        //删除指定identifier的缓存图片
        //        self.imagePickerController?.removeCachesPictureForIdentifier("abc")
        //删除全部缓存图片
        if self.imagePicker?.removeCachesPictures() == true {
            imageView.image = nil
            print("删除全部缓存图片成功")
        }
    }
    
    //MARK:JHImagePickerControllerDelegate
    //当设置了缓存，且输入缓存identifier时返回该方法
    func selectImageFinishedAndCaches(_ image: UIImage, cachesIdentifier: String, isCachesSuccess: Bool) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    //当未设置缓存或缓存identifier为空时返回该方法
    func selectImageFinished(_ image: UIImage) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
