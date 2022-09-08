//
//  BlockbusterTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - BlockbusterTableViewCell class

final class BlockbusterTableViewCell: DefaultTableViewCell<BlockbusterCollectionViewCell> {
    
    var dataSource: DefaultCollectionViewDataSource!
    var viewModel: TableViewCellItemViewModel!
    
    override func configure(with viewModel: TableViewCellItemViewModel) {
        self.viewModel = viewModel
        
        dataSource = DefaultCollectionViewDataSource(section: self.section)
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
    }
}
