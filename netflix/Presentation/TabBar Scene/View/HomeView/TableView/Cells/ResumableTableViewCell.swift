//
//  ResumableTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - ResumableTableViewCell class

final class ResumableTableViewCell: DefaultTableViewCell<ResumableCollectionViewCell> {
    
    var dataSource: DefaultCollectionViewDataSource<ResumableCollectionViewCell>!
    var viewModel: TableViewCellItemViewModel!
    
    override func configure(with viewModel: TableViewCellItemViewModel) {
        self.viewModel = viewModel
        
        dataSource = DefaultCollectionViewDataSource(section: section)
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
    }
}
