//
//  TableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CellInput protocol

private protocol CellInput {
    func viewDidLoad()
    func viewDidConfigure(section: Section,
                          with viewModel: HomeViewModel)
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
        let collectionView = UICollectionView(frame: bounds,
                                              collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerNib(T.self)
        contentView.addSubview(collectionView)
        collectionView.constraintToSuperview(contentView)
        return collectionView
    }()
    
    fileprivate(set) var dataSource: CollectionViewDataSource<T>!
    fileprivate var layout: CollectionViewLayout!
    
    deinit {
        layout = nil
        dataSource = nil
    }
    
    class func create(in tableView: UITableView,
                      for indexPath: IndexPath,
                      with viewModel: HomeViewModel) -> TableViewCell<T>? {
        guard let view = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath) as? TableViewCell<T>
        else { return nil }
        view.viewDidLoad()
        let section = viewModel.section(at: .init(rawValue: indexPath.section)!)
        view.viewDidConfigure(section: section, with: viewModel)
        return view
    }
    
    fileprivate func viewDidLoad() { backgroundColor = .black }
    
    func viewDidConfigure(section: Section,
                          with viewModel: HomeViewModel) {
        guard let indices = TableViewDataSource.Index(rawValue: section.id) else { return }
        
        dataSource = .init(collectionView: collectionView,
                           section: section,
                           viewModel: viewModel)
        
        switch indices {
        case .display: break
        case .ratable:
            layout = CollectionViewLayout(layout: .ratable, scrollDirection: .horizontal)
            collectionView.setCollectionViewLayout(layout, animated: false)
        default:
            layout = CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
}
