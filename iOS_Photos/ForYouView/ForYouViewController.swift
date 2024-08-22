//
//  ForYouViewController.swift
//  iOS_Photos
//
//  Created by 박병훈 on 8/20/24.
//

import Foundation
import UIKit

class ForYouViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var recommendedItems: [ForYouItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 컬렉션 뷰 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // 컬렉션 뷰 초기화
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ForYouCell.self, forCellWithReuseIdentifier: "ForYouCell")
        
        self.view.addSubview(collectionView)
        
        // 샘플 데이터 설정
        setupSampleData()
    }
    
    func setupSampleData() {
        recommendedItems = [
            ForYouItem(title: "Memories from Last Summer", imageName: "summer_memory"),
            ForYouItem(title: "Family Moments", imageName: "family_moments"),
            ForYouItem(title: "Travel Highlights", imageName: "travel_highlights"),
            ForYouItem(title: "Best of 2023", imageName: "best_of_2023")
        ]
        
        collectionView.reloadData()
    }
}

extension ForYouViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForYouCell", for: indexPath) as! ForYouCell
        let item = recommendedItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(recommendedItems[indexPath.item].title)")
    }
}

struct ForYouItem {
    let title: String
    let imageName: String
}

class ForYouCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 40))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: frame.height - 40, width: frame.width - 20, height: 40))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ForYouItem) {
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
    }
}
