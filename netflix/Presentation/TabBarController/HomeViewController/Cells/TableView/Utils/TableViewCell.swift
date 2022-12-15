//
//  TableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

typealias RatedTableViewCell = TableViewCell<RatedCollectionViewCell>
typealias ResumableTableViewCell = TableViewCell<ResumableCollectionViewCell>
typealias StandardTableViewCell = TableViewCell<StandardCollectionViewCell>

final class TableViewCell<T>: UITableViewCell where T: UICollectionViewCell {
    enum SortOptions {
        case rating
    }
    
    lazy var collectionView = createCollectionView()
    var dataSource: HomeCollectionViewDataSource<T>!
    var layout: CollectionViewLayout!
    
    init(with viewModel: HomeViewModel,
         for indexPath: IndexPath,
         actions: HomeCollectionViewDataSourceActions? = nil) {
        super.init(style: .default, reuseIdentifier: TableViewCell<T>.reuseIdentifier)
        let index = HomeTableViewDataSource.Index(rawValue: indexPath.section)!
        let section = viewModel.section(at: index)
        self.dataSource = HomeCollectionViewDataSource(
            on: collectionView,
            section: section,
            viewModel: viewModel,
            with: actions)
        self.viewDidLoad()
        self.viewDidConfigure(section: section, viewModel: viewModel, with: actions)
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
