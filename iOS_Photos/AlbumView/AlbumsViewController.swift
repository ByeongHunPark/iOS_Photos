//
//  AlbumsViewController.swift
//  iOS_Photos
//
//  Created by 박병훈 on 8/22/24.
//

import Foundation
import UIKit
import Photos

class AlbumsViewController: UIViewController {
    
    var tableView: UITableView!
    var userAlbums: PHFetchResult<PHAssetCollection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "앨범"
        self.view.backgroundColor = .white
        
        // 테이블 뷰 초기화
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        self.view.addSubview(tableView)
        
        // 앨범 로드
        fetchAlbums()
    }
    
    func fetchAlbums() {
        let options = PHFetchOptions()
        userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options)
        tableView.reloadData()
    }
}

extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAlbums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        if let album = userAlbums?[indexPath.row] {
            cell.textLabel?.text = album.localizedTitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let album = userAlbums?[indexPath.row] {
            let albumDetailVC = AlbumDetailViewController()
            albumDetailVC.album = album
            albumDetailVC.modalPresentationStyle = .fullScreen // 전체 화면 모달
            self.present(albumDetailVC, animated: true, completion: nil)
        }
    }
}
