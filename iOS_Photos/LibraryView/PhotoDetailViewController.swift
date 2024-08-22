//
//  PhotoDetailViewController.swift
//  iOS_Photos
//
//  Created by 박병훈 on 8/22/24.
//

import Foundation
import UIKit
import Photos

class PhotoDetailViewController: UIViewController {
    
    var imageView: UIImageView!
    var asset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        // 이미지 뷰 초기화
        imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        // 닫기 버튼 추가
        let closeButton = UIButton(frame: CGRect(x: 20, y: 40, width: 50, height: 50))
        closeButton.setTitle("닫기", for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        // 선택된 사진 로드
        if let asset = asset {
            displayPhoto(asset: asset)
        }
    }
    
    func displayPhoto(asset: PHAsset) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: self.view.bounds.size, contentMode: .aspectFit, options: options) { (result, _) in
            self.imageView.image = result
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
