//
//  PhotoCell.swift
//  iOS_Photos
//
//  Created by 박병훈 on 8/22/24.
//

import Foundation
import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: self.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with asset: PHAsset) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: self.contentView.bounds.size, contentMode: .aspectFill, options: options) { (result, _) in
            self.imageView.image = result
        }
    }
}


