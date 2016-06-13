# JHUIImagePickerController
EasyUIImagePickerController for Swift


1.声明
`var imagePickerController:JHImagePickerController?`

2.初始化

    //初始化方法一
    //        imagePickerController = JHImagePickerController()
    //初始化方法一的补充设置(若需要缓存时才设置)
    //设置是否缓存(默认为false)
    //        imagePickerController?.isCaches = true
    //设置缓存id（当需要缓存时才设置）
    //        imagePickerController?.identifier = "xx"

    //初始化方法二
    imagePickerController = JHImagePickerController(isCaches: true, identifier: "abc")

3.设置代理 JHImagePickerControllerDelegate
`imagePickerController?.delegate = self`

4.
选取图片来自相册 注意使用[weak self] 防止强引用

    self.imagePickerController?.selectImageFromAlbumSuccess({[weak self] (imagePickerController) in
        if let strongSelf = self {
            strongSelf.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }, Fail: {
        //SVProgressHUD.showErrorWithStatus("无法获取照片权限")
    })

选取图片来自相机 注意使用[weak self] 防止强引用

    self.imagePickerController?.selectImageFromCameraSuccess({[weak self](imagePickerController) in
        if let strongSelf = self {
            strongSelf.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }, Fail: {
        //SVProgressHUD.showErrorWithStatus("无法获取相机权限")
    })


5.
当未设置缓存或缓存identifier为空时返回该方法

    func selectImageFinished(image: UIImage) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

当设置了缓存，且输入缓存identifier时返回该方法(未设置缓存时可以不实现)

    func selectImageFinishedAndCaches(image: UIImage, cachesIdentifier: String, isCachesSuccess: Bool) {
        if isCachesSuccess == true {
            imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

6.根据identifier读取缓存图片(若读取失败，默认返回的image?.accessibilityIdentifier == "jhSurprise.jpg")

    let image = self.imagePickerController?.readImageFromCaches("abc")
    if image?.accessibilityIdentifier != "jhSurprise.jpg" {
        imageView.image = image
    }else {
        print("读取缓存照片失败,请检查图片identifier是否存在")
        imageView.image = image
    }

7.删除指定identifier的缓存图片(删除id：abc)
`self.imagePickerController?.removeCachesPictureForIdentifier("abc")`
删除全部缓存图片

    if self.imagePickerController?.removeCachesPictures() == true {
        print("删除全部缓存图片成功")
    }

