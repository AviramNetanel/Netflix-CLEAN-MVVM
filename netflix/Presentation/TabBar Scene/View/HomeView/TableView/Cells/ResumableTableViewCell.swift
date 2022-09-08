//
//  ResumableTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - ResumableTableViewCell class

final class ResumableTableViewCell: DefaultTableViewCell, TableViewCell {
    
    typealias Cell = ResumableCollectionViewCell
    
    static var reuseIdentifier = String(describing: ResumableTableViewCell.self)
    
    var collectionView: UICollectionView!
    var section: Section!
    
    var dataSource: CollectionViewDataSource!
    var viewModel: TableViewCellItemViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(section: Section) {
        self.init(style: .default, reuseIdentifier: ResumableTableViewCell.reuseIdentifier)
        self.section = section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
    
    private func setupViews() {
        
    }
}

// MARK: - TableViewCell implementation

extension ResumableTableViewCell {
    
    func configure(with viewModel: TableViewCellItemViewModel) {
        self.viewModel = viewModel
        
        dataSource = DefaultCollectionViewDataSource(section: self.section)
    }
}
