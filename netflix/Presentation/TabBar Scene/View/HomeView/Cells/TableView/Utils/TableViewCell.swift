//
//  TableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CellInput protocol

private protocol CellInput {
    func configure(section: Section, with viewModel: HomeViewModel)
}

// MARK: - CellOutput protocol

private protocol CellOutput {}

// MARK: - Cell typealias

private typealias Cell = CellInput & CellOutput

// MARK: - TableViewCell class

class TableViewCell<T>: UITableViewCell, Cell where T: UICollectionViewCell {
    
    enum SortOptions {
        case rating
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        contentView.addSubview(collectionView)
        return collectionView
    }()
    
    private(set) var dataSource: CollectionViewDataSource<T>!
    
    var viewModel: HomeViewModel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .black
        self.constraintSubviews()
    }
    
    deinit {
        dataSource = nil
        viewModel = nil
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - CellInput implementation

extension TableViewCell {
    
    func configure(section: Section, with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        guard let indices = TableViewDataSource.Index(rawValue: section.id) else { return }
        
        dataSource = .init(collectionView: collectionView,
                           section: section,
                           viewModel: viewModel)
        
        guard !(collectionView.collectionViewLayout is CollectionViewLayout) else { return }
        
        switch indices {
        case .display:
            break
        case .ratable:
            let configuration = CollectionViewLayout.ratableConfigurations(for: collectionView)
            let layout = CollectionViewLayout(configuration: configuration)
            collectionView.setCollectionViewLayout(layout, animated: false)
        default:
            let configuration = CollectionViewLayout.standardConfigurations(for: collectionView)
            let layout = CollectionViewLayout(configuration: configuration)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
}
