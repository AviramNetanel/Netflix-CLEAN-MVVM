//
//  BrowseOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 07/12/2022.
//

import UIKit.UICollectionView

final class BrowseOverlayView: UIView {
    let viewModel: BrowseOverlayViewModel
    
    private lazy var collectionView: UICollectionView = createCollectionView()
    
    var dataSource: BrowseOverlayCollectionViewDataSource? {
        didSet { dataSourceDidChange() }
    }
    
    init(on parent: UIView, with viewModel: HomeViewModel) {
        self.viewModel = BrowseOverlayViewModel(with: viewModel)
        
        super.init(frame: parent.bounds)
        
        /// Updates root coordinator's `browseOverlayView` property.
        viewModel.coordinator?.viewController?.browseOverlayView = self
        
        parent.addSubview(self)
        self.constraintToSuperview(parent)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createCollectionView() -> UICollectionView {
        let layout = CollectionViewLayout(layout: .homeOverlay, scrollDirection: .vertical)
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.register(StandardCollectionViewCell.nib,
                                forCellWithReuseIdentifier: StandardCollectionViewCell.reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)
        collectionView.backgroundColor = .black
        addSubview(collectionView)
        return collectionView
    }
    
    private func dataSourceDidChange() {
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
}
