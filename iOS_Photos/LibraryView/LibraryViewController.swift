//
//  LibraryViewController.swift
//  iOS_Photos
//
//  Created by 박병훈 on 8/20/24.
//

import UIKit
import Photos

class LibraryViewController: UIViewController {

    var collectionView: UICollectionView!
    var allPhotos: PHFetchResult<PHAsset>?
    var currentZoomLevel: CGFloat = 3 // 초기 3개의 셀이 보이도록 설정
    var lastScale: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        updateItemSize(for: layout, zoomLevel: currentZoomLevel)

        // 컬렉션 뷰 초기화
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

        self.view.addSubview(collectionView)

        // 핀치 제스처 인식기 추가
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        self.view.addGestureRecognizer(pinchGesture)

        // 사진 접근 권한 요청 및 사진 로드
        checkPhotoLibraryPermission()
    }

    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        if gesture.state == .changed {
            let scale = gesture.scale

            if scale > 1 {
                // 확대
                if currentZoomLevel == 13 {
                    currentZoomLevel = 5
                } else if currentZoomLevel == 5 {
                    currentZoomLevel = 3
                }
            } else if scale < 1 {
                // 축소
                if currentZoomLevel == 3 {
                    currentZoomLevel = 5
                } else if currentZoomLevel == 5 {
                    currentZoomLevel = 13
                }
            }

            // 아이템 크기 업데이트
            updateItemSize(for: layout, zoomLevel: currentZoomLevel)
            layout.invalidateLayout() // 레이아웃 갱신

            gesture.scale = 1.0 // 제스처 스케일 리셋
        }
    }


    func updateItemSize(for layout: UICollectionViewFlowLayout, zoomLevel: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow = zoomLevel
        let itemWidth = (screenWidth / itemsPerRow) - 1 // 셀 사이의 간격을 고려
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
    }

    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            fetchPhotos()
        case .denied, .restricted:
            print("사진 접근이 거부되었습니다.")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    self.fetchPhotos()
                }
            }
        @unknown default:
            break
        }
    }

    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToBottom()
        }
    }

    func scrollToBottom() {
        guard let allPhotos = allPhotos, allPhotos.count > 0 else { return }
        let lastItemIndex = IndexPath(item: allPhotos.count - 1, section: 0)
        collectionView.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
    }
}

extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell

        if let asset = allPhotos?[indexPath.item] {
            cell.configure(with: asset)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let asset = allPhotos?[indexPath.item] {
            let detailVC = PhotoDetailViewController()
            detailVC.asset = asset
            detailVC.modalPresentationStyle = .fullScreen
            self.present(detailVC, animated: true, completion: nil)
        }
    }
}
