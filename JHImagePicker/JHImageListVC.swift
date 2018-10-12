//
//  JHImageListVC.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/13.
//
//

import UIKit
import Photos

class JHListtem {
    
    var title: String?
    var result: PHFetchResult<PHAsset>
    
    init(title: String?, result: PHFetchResult<PHAsset>) {
        self.title = title
        self.result = result
    }
    
    static func ==(lhs: JHListtem, rhs: JHListtem) -> Bool {
        return lhs.title == rhs.title && lhs.result == rhs.result
    }
}

class JHImageListVC: UIViewController {
    
    var myBlock: JHImagePhotosCompletion?
    var items: [JHListtem] = []
    lazy var imageManager = PHCachingImageManager()
    
    var isFirstEnter = true
    var listMaxCount: Int = 9
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstEnter && isEnablePhoto {
            goPhotosVC()
        }
        
    }
    
    let isEnablePhoto = authorize()
    private var unableLable: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setRightBtn()
        
        if isEnablePhoto {
            title = "照片"
            loadImageDatas()
            loadTableView()
        } else {
            showUnablePhoto()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: NOTI_jhPHAuthorized, object: nil)
    }
    
    func goPhotosVC() {
        let vc = JHImagePhotosVC()
        vc.item = items.first
        vc.maxCount = listMaxCount
        vc.block = myBlock
        
        navigationController?.pushViewController(vc, animated: false)
        isFirstEnter = false
    }
    
    @objc func refreshUI() {
        unableLable?.isHidden = true
        loadImageDatas()
        loadTableView()
        goPhotosVC()
    }
    
    // MARK: - 逻辑处理
    func loadImageDatas() {
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: smartOptions)
        convertCollection(smartAlbums)
    }
    
    private func convertCollection(_ collection:PHFetchResult<PHAssetCollection>){
        
        for i in 0..<collection.count{
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let item = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: item , options: resultsOptions)
            // 移除 最近删除 和 已隐藏 数据源
            if item.localizedTitle == "最近删除" || item.localizedTitle == "已隐藏" || item.localizedTitle == "Recently Deleted" {
                continue
            }
            // 移除 图片为空的相册
            if assetsFetchResult.count < 1 {
                continue
            }
            
            let jhItem = JHListtem(title: item.localizedTitle, result: assetsFetchResult)
            items.append(jhItem)
        }
        
        // 将 所有照片 数据源放到顶部
        var tempItem: JHListtem?
        for item in items {
            if item.title == "所有照片" {
                if let index = items.index(where: { $0 == item } ) {
                    tempItem = item
                    items.remove(at: index)
                    break
                }
            }
        }
        if tempItem != nil {
            items.insert(tempItem!, at: 0)
        }
        
    }
    
    // MARK: - UI事件
    @objc func cancelClicked() {
        NotificationCenter.default.removeObserver(self)
        dismiss(animated: true)
    }
    
    // MARK: - UI渲染
    private func setRightBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClicked))
    }
    
    private func showUnablePhoto() {
        let label = UILabel()
        label.text = "请在iPhone的“设置-隐私-照片”选项中，允许本应用访问你的手机相册。"
        label.frame = CGRect(x: 60, y: 120, width: jhSCREEN.width - 120, height: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        view.addSubview(label)
        unableLable = label
    }
    
    private func loadTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    lazy var tableView: UITableView = {
        let table: UITableView = UITableView(frame: self.view.bounds, style: .plain)
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.white
        table.separatorStyle = .none
        return table
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var imageSize: CGSize = {
        let scale = UIScreen.main.scale
        return CGSize(width: JHCellHeight * scale , height: JHCellHeight * scale)
    }()
    
    lazy var options: PHImageRequestOptions = {
        let o = PHImageRequestOptions()
        o.deliveryMode = .opportunistic
        o.resizeMode = .fast
        return o
    }()
    
    deinit {
        print("dealloc ",self)
    }
    
}

extension JHImageListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = JHImagePhotosVC()
        vc.item = items[indexPath.row]
        vc.maxCount = listMaxCount
        vc.block = myBlock
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JHImageListCell.configWith(table: tableView)
        cell.item = items[indexPath.row]
        if let asset = items[indexPath.row].result.lastObject {
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: { (image, dic) in
                cell.iconIV.image = image
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JHCellHeight
    }
}
