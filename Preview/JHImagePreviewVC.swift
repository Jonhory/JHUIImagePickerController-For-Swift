//
//  JHImagePreviewVC.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/17.
//
//

import UIKit

class JHImagePreviewVC: UIViewController, JHImagePreviewNavDelegate {

    var models: [JHPhotoItem] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        loadUI()
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    var nav: JHImagePreviewNav!
    var collection: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    private func loadUI() {
        // 头部
        let f = CGRect(x: 0, y: 0, width: view.bounds.width, height: 64)
        nav = JHImagePreviewNav(frame: f)
        nav.delegate = self
        view.addSubview(nav)
        
        loadCollectionView()
    }
    
    private func loadCollectionView() {
        layout.scrollDirection = .horizontal
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.scrollsToTop = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentOffset = CGPoint(x: 0, y: 0)
        collection.contentSize = CGSize(width: CGFloat(models.count)*(view.bounds.width + 20), height: 0)
        view.addSubview(collection)
        collection.register(JHImagePreviewCell.self, forCellWithReuseIdentifier: JHImagePreviewCellID)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.itemSize = CGSize(width: view.bounds.width + 20, height: view.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collection.frame = CGRect(x: -10, y: 0, width: view.bounds.width+20, height: view.bounds.height)
        collection.collectionViewLayout = layout
    }

    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension JHImagePreviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JHImagePreviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: JHImagePreviewCellID, for: indexPath) as! JHImagePreviewCell
        return cell
    }
    
}

extension JHImagePreviewVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    
}
