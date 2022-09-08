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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
    
    func configure(with viewModel: TableViewCellItemViewModel) {}
    
    // MARK: Private
    
    private func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection  = .horizontal
        
        collectionView = .init(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        contentView.addSubview(collectionView)
        
        collectionView.register(RatableCollectionViewCell.nib,
                                forCellWithReuseIdentifier: RatableCollectionViewCell.reuseIdentifier)
        collectionView.register(ResumableCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ResumableCollectionViewCell.reuseIdentifier)
        collectionView.register(StandardCollectionViewCell.nib,
                                forCellWithReuseIdentifier: StandardCollectionViewCell.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Configurable implementation

extension DefaultTableViewCell: Configurable {}
