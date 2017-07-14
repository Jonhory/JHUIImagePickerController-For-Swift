//
//  JHImageListController.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/13.
//
//

import UIKit
import Photos

class JHPhotoItem {
    var title: String?
    var result: PHFetchResult<PHAsset>
    
    init(title: String?, result: PHFetchResult<PHAsset>) {
        self.title = title
        self.result = result
    }
}

class JHImageListController: UIViewController {

    var items: [JHPhotoItem] = []
    lazy var imageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setRightBtn()
        
        let isEnablePhoto = authorize()
        if isEnablePhoto {
            print("我可是有权限哦")
            title = "照片"
            loadImageDatas()
            loadTableView()
        } else {
            showUnablePhoto()
        }
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
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let item = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: item , options: resultsOptions)
            
            if assetsFetchResult.count > 0{
                print("title:",item.localizedTitle ?? "nil", "   result:",assetsFetchResult)
                let jhItem = JHPhotoItem(title: item.localizedTitle, result: assetsFetchResult)
                items.append(jhItem)
            }
        }
        
    }
    
    // MARK: - UI事件
    func cancelClicked() {
        dismiss(animated: true)
    }
    
    // MARK: - UI渲染
    private func setRightBtn() {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 34, height: 20.5)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.white, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }

    private func showUnablePhoto() {
        let label = UILabel()
        label.text = "请在iPhone的“设置-隐私-照片”选项中，允许本应用访问你的手机相册。"
        label.frame = CGRect(x: 60, y: 120, width: SCREEN.width - 120, height: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        view.addSubview(label)
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

extension JHImageListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JHImageListCell.configWith(table: tableView)
        cell.item = items[indexPath.row]
        
        if let asset = items[indexPath.row].result.firstObject {
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
