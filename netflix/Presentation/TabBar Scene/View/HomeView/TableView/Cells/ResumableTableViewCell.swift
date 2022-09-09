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
                       at indexPath: IndexPath) -> ResumableTableViewCell {
        tableView.register(ResumableTableViewCell.self,
                           forCellReuseIdentifier: ResumableTableViewCell.reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(ofType: ResumableTableViewCell.self, at: indexPath)
        cell.section = viewModel.sections.value.first!
        let cellViewModel = TableViewCellItemViewModel(section: cell.section)
        cell.configure(with: cellViewModel)
        return cell
    }
}
