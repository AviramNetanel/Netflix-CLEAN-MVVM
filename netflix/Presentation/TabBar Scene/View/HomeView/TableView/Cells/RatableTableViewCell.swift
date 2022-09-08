//
//  RatableTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - RatableTableViewCell class

final class RatableTableViewCell: DefaultTableViewCell, TableViewCell {
    
    typealias Cell = RatableCollectionViewCell
    
    static var reuseIdentifier = String(describing: RatableTableViewCell.self)

    var collectionView: UICollectionView!
    var section: Section! {
        didSet {
            setupViews()
        }
    }
    
    var dataSource: DefaultCollectionViewDataSource!
    var viewModel: TableViewCellItemViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
    
    private func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection  = .horizontal
        
        collectionView = .init(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        contentView.addSubview(collectionView)
        
        collectionView.register(UINib(nibName: String(describing: RatableCollectionViewCell.self),
                                      bundle: .main),
                                forCellWithReuseIdentifier: RatableCollectionViewCell.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - TableViewCell implmenetation

extension RatableTableViewCell {
    
    func configure(with viewModel: TableViewCellItemViewModel) {
        self.viewModel = viewModel
        
        dataSource = DefaultCollectionViewDataSource(section: self.section)
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
    }
}
