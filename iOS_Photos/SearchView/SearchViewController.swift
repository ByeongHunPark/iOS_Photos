//
//  SearchViewController.swift
//  iOS_Photos
//
//  Created by 박병훈 on 8/22/24.
//

import Foundation
import UIKit
import Photos

class SearchViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var allPhotos: PHFetchResult<PHAsset>?
    var filteredPhotos: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "검색"
        self.view.backgroundColor = .white
        
        // 검색 바 초기화
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "사진 검색"
        self.navigationItem.titleView = searchBar
        
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
        
        // 모든 사진 로드
        fetchAllPhotos()
    }
    
    func fetchAllPhotos() {
        let fetchOptions = PHFetchOptions()
        allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPhotos(with: searchText)
    }
    
    func filterPhotos(with text: String) {
        guard let allPhotos = allPhotos else { return }
        
        if text.isEmpty {
            filteredPhotos.removeAll()
        } else {
            filteredPhotos = allPhotos.objects(at: IndexSet(0..<allPhotos.count)).filter { asset in
                // 예시: 여기서는 사진 파일 이름에 기반한 검색을 가정합니다.
                // 실제로는 메타데이터를 이용해 더 복잡한 검색을 할 수 있습니다.
                return asset.localIdentifier.contains(text)
            }
        }
        
        collectionView.reloadData()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let asset = filteredPhotos[indexPath.item]
        cell.configure(with: asset)
        return cell
    }
}
