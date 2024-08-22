//
//  AlbumDetailViewController.swift
//  iOS_Photos
//
//  Created by 박병훈 on 8/22/24.
//

import Foundation
import UIKit
import Photos

class AlbumDetailViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var album: PHAssetCollection?
    var albumPhotos: PHFetchResult<PHAsset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = album?.localizedTitle
        self.view.backgroundColor = .white
        
        // 컬렉션 뷰 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        // 컬렉션 뷰 초기화
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        self.view.addSubview(collectionView)
        
        // 닫기 버튼 추가
        let closeButton = UIButton(frame: CGRect(x: 20, y: 40, width: 50, height: 50))
        closeButton.setTitle("닫기", for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        // 앨범의 사진 로드
        fetchPhotosFromAlbum()
    }
    
    func fetchPhotosFromAlbum() {
        guard let album = album else { return }
        
        let options = PHFetchOptions()
        albumPhotos = PHAsset.fetchAssets(in: album, options: options)
        collectionView.reloadData()
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AlbumDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if let asset = albumPhotos?[indexPath.item] {
            cell.configure(with: asset)
        }
        return cell
    }
}
