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
}

// MARK: - TableViewCell protocol

protocol TableViewCell: TableViewCellInput, TableViewCellOutput {}

// MARK: - DefaultTableViewCell class

class DefaultTableViewCell<Cell>: UITableViewCell, TableViewCell where Cell: Configurable {
    
    var collectionView: UICollectionView!
    
    var section: Section! {
        didSet { setupViews() }
    }
    
    var viewModel: TableViewCellItemViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
    
    private func setupViews() {
        collectionView = .init(frame: bounds, collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: TableViewCellItemViewModel) {}
}

// MARK: - Configurable implementation

extension DefaultTableViewCell: Configurable {}
