//
//  TableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - TableViewCellInput protocol

protocol TableViewCellInput {
    func configure(with viewModel: TableViewCellItemViewModel)
}

// MARK: - TableViewCellOutput protocol

protocol TableViewCellOutput {
    var collectionView: UICollectionView! { get }
    var section: Section! { get }
    static var reuseIdentifier: String { get }
}

// MARK: - TableViewCell protocol

protocol TableViewCell: TableViewCellInput, TableViewCellOutput {
    associatedtype Cell where Cell: UICollectionViewCell
}

// MARK: - DefaultTableViewCell class

open class DefaultTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
}
