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

private protocol CellOutput {
    associatedtype T: UICollectionViewCell
    var collectionView: UICollectionView { get }
    var dataSource: CollectionViewDataSource<T>! { get }
    var layout: CollectionViewLayout! { get }
}

// MARK: - Cell typealias

private typealias Cell = CellInput & CellOutput

// MARK: - TableViewCell class

class TableViewCell<T>: UITableViewCell, Cell where T: UICollectionViewCell {
    
    enum SortOptions {
        case rating
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.constraintToSuperview(contentView)
        return collectionView
    }()
    
    fileprivate(set) var dataSource: CollectionViewDataSource<T>!
    fileprivate var layout: CollectionViewLayout!
    
    var viewModel: HomeViewModel!
    
    deinit {
        layout = nil
        dataSource = nil
        viewModel = nil
    }
    
    func configure(section: Section, with viewModel: HomeViewModel) {
        backgroundColor = .black
        
        self.viewModel = viewModel
        
        guard let indices = TableViewDataSource.Index(rawValue: section.id) else { return }
        
        dataSource = .init(collectionView: collectionView,
                           section: section,
                           viewModel: viewModel)
        
        switch indices {
        case .display:
            break
        case .ratable:
            layout = CollectionViewLayout(layout: .ratable)
            collectionView.setCollectionViewLayout(layout, animated: false)
        default:
            layout = CollectionViewLayout(layout: .standard)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
}
