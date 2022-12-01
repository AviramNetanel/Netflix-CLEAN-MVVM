//
//  TableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - RatedTableViewCell typealias

typealias RatedTableViewCell = TableViewCell<RatedCollectionViewCell>

// MARK: - ResumableTableViewCell typealias

typealias ResumableTableViewCell = TableViewCell<ResumableCollectionViewCell>

// MARK: - StandardTableViewCell typealias

typealias StandardTableViewCell = TableViewCell<StandardCollectionViewCell>

// MARK: - CellInput protocol

private protocol CellInput {
    func viewDidLoad()
    func viewDidConfigure(section: Section, viewModel: HomeViewModel, with actions: HomeCollectionViewDataSourceActions?)
}

// MARK: - CellOutput protocol

private protocol CellOutput {
    associatedtype T: UICollectionViewCell
    var collectionView: UICollectionView { get }
    var dataSource: HomeCollectionViewDataSource<T>! { get }
    var layout: CollectionViewLayout! { get }
}

// MARK: - Cell typealias

private typealias Cell = CellInput & CellOutput

// MARK: - TableViewCell class

final class TableViewCell<T>: UITableViewCell, Cell where T: UICollectionViewCell {
    
    enum SortOptions {
        case rating
    }
    
    fileprivate lazy var collectionView = createCollectionView()
    fileprivate(set) var dataSource: HomeCollectionViewDataSource<T>!
    fileprivate var layout: CollectionViewLayout!
    
    init(using diProvider: HomeViewDIProvider,
         for indexPath: IndexPath,
         actions: HomeCollectionViewDataSourceActions? = nil) {
        super.init(style: .default, reuseIdentifier: TableViewCell<T>.reuseIdentifier)
        let index = HomeTableViewDataSource.Index(rawValue: indexPath.section)!
        let section = diProvider.dependencies.homeViewModel.section(at: index)
        self.dataSource = HomeCollectionViewDataSource(on: collectionView,
                                                   section: section,
                                                   viewModel: diProvider.dependencies.homeViewModel,
                                                   with: actions)
        self.viewDidLoad()
        self.viewDidConfigure(section: section, viewModel: diProvider.dependencies.homeViewModel, with: actions)
    }
    
    deinit {
        layout = nil
        dataSource = nil
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerNib(T.self)
        contentView.addSubview(collectionView)
        collectionView.constraintToSuperview(contentView)
        return collectionView
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
    }
    
    func viewDidConfigure(section: Section,
                          viewModel: HomeViewModel,
                          with actions: HomeCollectionViewDataSourceActions? = nil) {
        guard let indices = HomeTableViewDataSource.Index(rawValue: section.id) else { return }
        if case .display = indices {
            ///
        } else if case .ratable = indices {
            layout = CollectionViewLayout(layout: .ratable, scrollDirection: .horizontal)
            collectionView.setCollectionViewLayout(layout, animated: false)
        } else {
            layout = CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
}
