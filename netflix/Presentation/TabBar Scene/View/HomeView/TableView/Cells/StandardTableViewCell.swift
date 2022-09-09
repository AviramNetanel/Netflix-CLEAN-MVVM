//
//  StandardTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - StandardTableViewCell class

final class StandardTableViewCell: DefaultTableViewCell<StandardCollectionViewCell> {
    
    var dataSource: DefaultCollectionViewDataSource<StandardCollectionViewCell>!
    
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
                       at indexPath: IndexPath) -> StandardTableViewCell {
        tableView.register(StandardTableViewCell.self,
                           forCellReuseIdentifier: StandardTableViewCell.reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(ofType: StandardTableViewCell.self, at: indexPath)
        cell.section = viewModel.sections.value.first!
        let cellViewModel = TableViewCellItemViewModel(section: cell.section)
        cell.configure(with: cellViewModel)
        return cell
    }
}
