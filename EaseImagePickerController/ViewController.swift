//
//  ViewController.swift
//  EaseImagePickerController
//
//  Created by jonhory on 16/6/12.
//
//

import UIKit
import Photos

class ViewController: UIViewController,JHImagePickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
//        loadImages()
    }
    
    func loadImages() {
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: smartOptions)
        convertCollection(smartAlbums)
    }
    
    private func convertCollection(_ collection:PHFetchResult<PHAssetCollection>){
        
        for i in 0..<collection.count{
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            if assetsFetchResult.count > 0{
//                items.append(ZZImageItem(title: c.localizedTitle, fetchResult: assetsFetchResult))
                print("title:",c.localizedTitle ?? "nil", "   result:",assetsFetchResult)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = SelectViewController()
//        present(vc, animated: true)
        _ = jh_presentPhotoVC(3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

