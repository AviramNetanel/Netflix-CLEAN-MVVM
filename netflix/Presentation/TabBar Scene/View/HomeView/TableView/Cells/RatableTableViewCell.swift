//
//  RatableTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - RatableTableViewCell class

final class RatableTableViewCell: DefaultTableViewCell<RatableCollectionViewCell> {
    
    var dataSource: DefaultCollectionViewDataSource<RatableCollectionViewCell>!
    
    override func configure(with viewModel: TableViewCellItemViewModel) {
        self.viewModel = viewModel
        
        dataSource = DefaultCollectionViewDataSource(section: section)
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
    }
    
    static func create(tableView: UITableView,
                       viewModel: HomeViewModel,
                       at indexPath: IndexPath) -> RatableTableViewCell {
        tableView.register(RatableTableViewCell.self,
                           forCellReuseIdentifier: RatableTableViewCell.reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(ofType: RatableTableViewCell.self, at: indexPath)
        cell.section = viewModel.sections.value.first!
        let cellViewModel = TableViewCellItemViewModel(section: cell.section)
        cell.configure(with: cellViewModel)
        return cell
    }
}
