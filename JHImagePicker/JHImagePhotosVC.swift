//
//  JHImagePhotosVC.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/15.
//
//

import UIKit
import Photos

class JHPhotoItem {
    // 数据源
    var asset: PHAsset?
    // 是否选中
    var isSelected = false
    // 是否显示蒙版
    var isAble = true
    // 是否展示动画
    var isNeedAnimated = false
    
    // 选中时显示的数字
    var index: Int = 1
    var indexP: IndexPath?
    var image: UIImage?
    
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    static func ==(lhs: JHPhotoItem, rhs: JHPhotoItem) -> Bool {
        return lhs.asset == rhs.asset && lhs.index == rhs.index
    }
    
    // 获取原图
    func originalImage(_ finished: @escaping (_ origin: UIImage) -> Void) {
        if let ass = self.asset {
            getOriginalImage(ass, finished: { (image) in
                finished(image)
            })
        }
    }
}

typealias JHImagePhotosCompletion = (_ images: [JHPhotoItem]) -> Void

class JHImagePhotosVC: UIViewController {

    var item: JHListtem? {
        didSet {
            title = item?.title
            assets = item?.result
        }
    }
    var block: JHImagePhotosCompletion?
    
    // 最多选择张数
    public var maxCount: Int = 9
    
    var collectionView: UICollectionView?
    var assets: PHFetchResult<PHAsset>!
    // 数据源
    var photos: [JHPhotoItem] = []
    // 获取图片
    var imageManager = PHCachingImageManager()
    // 图片缓存
    var imagesDict: [Int: UIImage] = [:]
    // 已选图片
    var selectedPhotos: [JHPhotoItem] = []
    // 是否已展示蒙版
    var isShowMask = false
    // 是否第一次进入
    var isFirstLoad = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        scrollToBottom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setRightBtn()
        handleDatasource()
        loadCollectionView()
    }
    
    // MARK: - 逻辑处理
    func handleDatasource() {
        for i in 0..<assets.count {
            let asset = assets[i]
            let item = JHPhotoItem(asset: asset)
            photos.append(item)
        }
    }
    
    func scrollToBottom() {
        if assets.count <= 1 || !isFirstLoad { return }
        isFirstLoad = false
        
        let indexPath = IndexPath(row: assets.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
        
        let point = CGPoint(x: 0, y: collectionView!.contentOffset.y + 64 + 44)
        collectionView?.setContentOffset(point, animated: false)
    }
    
    // MARK: - UI事件
    @objc func cancelClicked() {
        dismiss(animated: true)
    }
    
    // MARK: - UI渲染
    private func setRightBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClicked))
    }
    
    private func loadCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: JHPhotosCellWH, height: JHPhotosCellWH)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let f = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 44 - TabbarSafeBottomMargin())
        collectionView = UICollectionView(frame: f, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(JHImagePhotosCell.self, forCellWithReuseIdentifier: JHImagePhotosCellID)
        collectionView?.contentInset = UIEdgeInsets(top: 3.5, left: 3.5, bottom: 3.5, right: 3.5)

        view.addSubview(collectionView!)
        
        /// 蒙板
        let f2 = CGRect(x: 0, y: jhSCREEN.height - 44 - TabbarSafeBottomMargin(), width: jhSCREEN.width, height: 44+TabbarSafeBottomMargin())
        barView = JHImagePhotosBar(frame: f2)
        barView.delegate = self
        view.addSubview(barView)
    }
    var barView: JHImagePhotosBar!
    
    lazy var imageSize: CGSize = {
        let scale = UIScreen.main.scale
        return CGSize(width: JHPhotosCellWH * scale , height: JHPhotosCellWH * scale)
    }()
    
    lazy var options: PHImageRequestOptions = {
        let o = PHImageRequestOptions()
        o.deliveryMode = .highQualityFormat
        o.resizeMode = .fast
        return o
    }()
    
    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("dealloc ",self)
    }

}

// MARK: - UICollectionViewDelegate
extension JHImagePhotosVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}


// MARK: - UICollectionViewDataSource
extension JHImagePhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JHImagePhotosCell = collectionView.dequeueReusableCell(withReuseIdentifier: JHImagePhotosCellID, for: indexPath) as! JHImagePhotosCell
        
        let item = photos[indexPath.row]
        item.indexP = indexPath
        cell.item = item
        cell.delegate = self
        if let asset = item.asset {
            if item.image == nil {
                
                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: { (image, dic) in
                    cell.iv.image = image
                    item.image = image
                })
            } else {
                cell.iv.image = item.image
            }
        }
        
        return cell
    }
}

// MARK: - JHImagePhotosCellDelegate 点击事件
extension JHImagePhotosVC: JHImagePhotosCellDelegate {
    func photsCellClicked(withItem: JHPhotoItem, btn: UIButton) {
        
        if withItem.isSelected {
            var indexPs: [IndexPath] = []
            if let index = selectedPhotos.index(where: { $0 == withItem } ) {
                selectedPhotos.remove(at: index)
                for i in (withItem.index - 1)..<selectedPhotos.count {
                    let otherItem = selectedPhotos[i]
                    otherItem.index -= 1
                    indexPs.append(otherItem.indexP!)
                }
            }
            withItem.isSelected = false
            btn.isSelected  = false
            
            if !reloadDatas() {
                collectionView?.reloadItems(at: indexPs)
            }
            
            barView.handleBarBtn(enable: selectedPhotos.count >= 1, count: selectedPhotos.count)
            
            return
        }
        if selectedPhotos.count >= maxCount {
            showMaxCountAlert()
            return
        }
        
        if withItem.isSelected == false {
            withItem.isSelected = true
            btn.isSelected = true
            let index = selectedPhotos.count + 1
            withItem.index = index
            let str = String.init(format: "%d", index)
            btn.setTitle(str, for: .selected)
            selectedPhotos.append(withItem)
            if selectedPhotos.count >= maxCount {
                withItem.isNeedAnimated = true
            } else {
                btn.showAnimation()
            }
        }
        if selectedPhotos.count >= 1 {
            barView.handleBarBtn(enable: true, count: selectedPhotos.count)
        }
        
        _ = reloadDatas()
    }
    
    func showMaxCountAlert() {
        let title = "最多只能选择\(maxCount)张照片"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let sure = UIAlertAction(title: "我知道了", style: .default)
        alert.addAction(sure)
        present(alert, animated: true)
    }
    
    func reloadDatas() -> Bool {
        if selectedPhotos.count == maxCount - 1 && isShowMask {
            isShowMask = false
            for photo in photos {
                photo.isAble = true
            }
            collectionView?.reloadData()
            return true
        }
        
        if selectedPhotos.count >= maxCount && !isShowMask{
            isShowMask = true
            for photo in photos {
                if photo.isSelected == false {
                    photo.isAble = false
                } else {
                    photo.isAble = true
                }
            }
            collectionView?.reloadData()
            return true
        }
        return false
    }
}

extension JHImagePhotosVC: JHImagePhotosBarDelegate {
    func barClicked(type: JHImagePhotosBarType) {
        switch type {
        case .preview:
            break
        case .finished:
            dismiss(animated: true, completion: nil)
            if block != nil {
                block!(selectedPhotos)
            }
            break
        }
    }
}
