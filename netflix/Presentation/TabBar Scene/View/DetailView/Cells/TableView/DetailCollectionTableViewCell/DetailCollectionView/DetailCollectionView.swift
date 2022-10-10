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
        let collectionView = UICollectionView(frame: bounds,
                                              collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.register(
            StandardCollectionViewCell.nib,
            forCellWithReuseIdentifier: StandardCollectionViewCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 16.0,
                                            left: .zero,
                                            bottom: .zero,
                                            right: .zero)
        addSubview(collectionView)
        return collectionView
    }()
    
    private var dataSource: DetailCollectionViewDataSource!
    
    private var viewModel: DetailViewModel!
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> DetailCollectionView {
        let view = DetailCollectionView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        view.viewModel = viewModel
        view.setupSubviews()
        view.collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.collectionView.constraintToSuperview(view)
        return view
    }
    
    private func setupSubviews() {
        setupDataSource()
    }
    
    private func setupDataSource() {
        let media = viewModel.state == .tvShows
            ? viewModel.section!.tvshows!
            : viewModel.section!.movies!
        dataSource = .init(collectionView: collectionView,
                           media: media,
                           with: viewModel)
        let layout = CollectionViewLayout(layout: .detail, scrollDirection: .vertical)
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
    }
}
