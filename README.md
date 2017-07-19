## JHImagePicker

UIImagePickerController for Swift

可缓存拍照的系统相机控制器和高仿微信图片选择器

### 导航:
* [快速接入](#快速接入)
* [使用步骤](#使用步骤)
* [TODO](#TODO)
* [特别提醒](#特别提醒)

![V2.1](https://ws1.sinaimg.cn/large/c6a1cfeagy1fhp0mw9ucij20ku112x6p.jpg)

![V2.1](https://ws1.sinaimg.cn/large/c6a1cfeagy1fhp0n950huj20ku1124qp.jpg)

![V2.1](https://ws1.sinaimg.cn/large/c6a1cfeagy1fhp0ndtz23j20o016otba.jpg)

### <a id="快速接入"></a>快速接入
将 `JHImagePicker` 文件夹拖入项目即可

### <a id="使用步骤"></a>使用步骤：

#### 单独使用图片选择器

            _ = self.jh_presentPhotoVC(1, completeHandler: { items in
                print("当前选中的图片数组", items)
                if let first = items.first {
                    print("获取回调图片：",first.image!)
                    
                    first.originalImage({ (image) in
                        self.imageView.image = image
                        print("获取原图：",image)
                    })
                    
                }
            })
            
#### 同时使用系统相机和图片选择器

1.声明

`var imagePickerController:JHImagePicker?`

2.初始化

    //初始化方法一
    //        imagePickerController = JHImagePicker()
    //初始化方法一的补充设置(若需要缓存时才设置)
    //设置是否缓存(默认为false)
    //        imagePickerController?.isCaches = true
    //设置缓存id（当需要缓存时才设置）
    //        imagePickerController?.identifier = "xx"

    //初始化方法二
    imagePickerController = JHImagePicker(isCaches: true, identifier: "abc")

3.设置代理 JHImagePickerDelegate

`imagePickerController?.delegate = self`

4.
选取图片来自相册 注意使用[weak self] 防止强引用

        let photoAction = UIAlertAction(title: "从手机相册选择", style: .default) { (action) in
            _ = self.jh_presentPhotoVC(1, completeHandler: { items in
                print("当前选中的图片数组", items)
                if let first = items.first {
                    print("获取回调图片：",first.image!)
                    
                    first.originalImage({ (image) in
                        self.imageView.image = image
                        print("获取原图：",image)
                    })
                    
                }
            })
        }

选取图片来自相机 注意使用[weak self] 防止强引用

    self.imagePickerController?.selectImageFromCameraSuccess({[weak self](imagePickerController) in
        if let strongSelf = self {
            strongSelf.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }, Fail: {
        //SVProgressHUD.showErrorWithStatus("无法获取相机权限")
    })


#### 以下方法跟系统相机拍照有关:

5.1当未设置缓存或缓存identifier为空时返回该方法

    func selectImageFinished(image: UIImage) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

5.2当设置了缓存，且输入缓存identifier时返回该方法(未设置缓存时可以不实现)

    func selectImageFinishedAndCaches(image: UIImage, cachesIdentifier: String, isCachesSuccess: Bool) {
        if isCachesSuccess == true {
            imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

6.根据identifier读取缓存图片(拍照结果)

    let image = self.imagePickerController?.readImageFromCaches("abc")
    if image?.accessibilityIdentifier != "jhSurprise.jpg" {
        imageView.image = image
    }else {
        print("读取缓存照片失败,请检查图片identifier是否存在")
    }

7.删除指定identifier的缓存图片(删除id：abc)

`self.imagePickerController?.removeCachesPictureForIdentifier("abc")`

删除全部缓存图片

    if self.imagePickerController?.removeCachesPictures() == true {
        print("删除全部缓存图片成功")
    }

### <a id="TODO"></a>TODO

* 仿微信预览模式

### <a id="特别提醒"></a>特别提醒

* 如果相簿的名字显示为英文，则需要添加为项目添加国际化。
  
  在 `Project` -> `Info` -> `Localizations` 下，添加 `Chinese(Simplified)` 即可。

* 若不想显示数据为 `0` 的相册，请使用 `JHImageListVC.swift` 中:

```
	if assetsFetchResult.count < 1 { continue }
```