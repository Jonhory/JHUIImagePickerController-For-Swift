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
    
    // 选中时显示的数字
    var index: Int = 1
    var indexP: IndexPath?
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    static func ==(lhs: JHPhotoItem, rhs: JHPhotoItem) -> Bool {
        return lhs.asset == rhs.asset && lhs.index == rhs.index
    }
}

class JHImagePhotosVC: UIViewController {

    var item: JHListtem? {
        didSet {
            title = item?.title
            assets = item?.result
        }
    }
    
    // 最多选择张数
    public var maxCount: Int = 9
    
    var collectionView: UICollectionView?
    var assets: PHFetchResult<PHAsset>!
    // 数据源
    var photos: [JHPhotoItem] = []
    var imageManager = PHCachingImageManager()
    // 已选图片
    var selectedPhotos: [JHPhotoItem] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        scrollToBottom()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setRightBtn()
        handleDatasource()
        print(assets)
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
        if assets.count <= 1 { return }
        let indexPath = IndexPath(row: assets.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
        
        let point = CGPoint(x: 0, y: collectionView!.contentOffset.y + 64 + 44)
        collectionView?.setContentOffset(point, animated: false)
    }
    
    // MARK: - UI事件
    func cancelClicked() {
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
        
        let f = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 44)
        collectionView = UICollectionView(frame: f, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(JHImagePhotosCell.self, forCellWithReuseIdentifier: JHImagePhotosCellID)
        collectionView?.contentInset = UIEdgeInsets(top: 3.5, left: 3.5, bottom: 3.5, right: 3.5)

        view.addSubview(collectionView!)
        
        /// 蒙板
        let f2 = CGRect(x: 0, y: jhSCREEN.height - 44, width: jhSCREEN.width, height: 44)
        let blurView = JHImagePhotosBar(frame: f2)
        view.addSubview(blurView)
    }
    
    lazy var imageSize: CGSize = {
        let scale = UIScreen.main.scale
        return CGSize(width: JHPhotosCellWH * scale , height: JHPhotosCellWH * scale)
    }()
    
    lazy var options: PHImageRequestOptions = {
        let o = PHImageRequestOptions()
        o.deliveryMode = .opportunistic
        o.resizeMode = .fast
        return o
    }()
    
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
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: { (image, dic) in
                cell.iv.image = image
            })
        }
        
        return cell
    }
}

// MARK: - JHImagePhotosCellDelegate 点击事件
extension JHImagePhotosVC: JHImagePhotosCellDelegate {
    func photsCellClicked(withItem: JHPhotoItem, btn: UIButton) {
        print(withItem.isSelected)
        if withItem.isSelected {
            if let index = selectedPhotos.index(where: { $0 == withItem } ) {
                selectedPhotos.remove(at: index)
                for i in (withItem.index - 1)..<selectedPhotos.count {
                    let otherItem = selectedPhotos[i]
                    otherItem.index -= 1
                    collectionView?.reloadItems(at: [otherItem.indexP!])
                }
            }
            withItem.isSelected = false
            btn.isSelected  = false
            return
        }
        if selectedPhotos.count >= maxCount {
            print("你最多只能选择\(maxCount)张照片")
            return
        }
        if withItem.isSelected == false {
            withItem.isSelected = true
            btn.isSelected = true
            let index = selectedPhotos.count + 1
            withItem.index = index
            let str = String.init(format: "%d", index)
            btn.setTitle(str, for: .selected)
            btn.showAnimation()
            selectedPhotos.append(withItem)
        }
        if selectedPhotos.count >= maxCount {
            for photo in photos {
                if photo.isSelected == false {
                    photo.isAble = false
                } else {
                    photo.isAble = true
                }
            }
            collectionView?.reloadData()
        }
    }
}
