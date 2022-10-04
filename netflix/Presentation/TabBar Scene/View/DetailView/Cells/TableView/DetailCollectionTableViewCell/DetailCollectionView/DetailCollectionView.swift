//
//  DetailCollectionView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailCollectionView class

final class DetailCollectionView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.register(StandardCollectionViewCell.nib, forCellWithReuseIdentifier: StandardCollectionViewCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        return collectionView
    }()
    
    private var dataSource: DetailCollectionCollectionViewDataSource!
    
    private var viewModel: DetailViewModel!
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> DetailCollectionView {
        let view = DetailCollectionView(frame: parent.bounds)
        view.viewModel = viewModel
        view.setupSubviews()
        return view
    }
    
    private func setupSubviews() {
        setupDataSource()
    }
    
    private func setupDataSource() {
        let media = viewModel.state == .tvShows
            ? viewModel.section!.tvshows!
            : viewModel.section!.movies!
        dataSource = .init(collectionView: collectionView, media: media, with: viewModel)
        collectionView.setCollectionViewLayout(layout: .detailCollection)
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
}
