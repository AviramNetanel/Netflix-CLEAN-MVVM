//
//  TableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

protocol TableViewCellInput {
    func configure(with viewModel: TableViewCellItemViewModel)
}

protocol TableViewCellOutput {
    var collectionView: UICollectionView! { get }
    var section: Section! { get }
    static var reuseIdentifier: String { get }
}

protocol TableViewCell: TableViewCellInput, TableViewCellOutput {
    associatedtype Cell where Cell: UICollectionViewCell
}

open class DefaultTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
}

//

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
    
    func configure(with viewModel: TableViewCellItemViewModel) {
        self.viewModel = viewModel
        
        dataSource = DefaultCollectionViewDataSource(section: self.section)
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
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

//

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
        self.init(style: .default, reuseIdentifier: String(describing: ResumableTableViewCell.self))
        self.section = section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
    
    func configure(with viewModel: TableViewCellItemViewModel) {
        self.viewModel = viewModel
        
        dataSource = DefaultCollectionViewDataSource(section: self.section)
    }
}

//

struct TableViewCellItemViewModel {
    let id: Int
    let title: String
    let tvshows: [Media]
    let movies: [Media]
    init(section: Section) {
        self.id = section.id
        self.title = section.title
        self.tvshows = section.tvshows ?? []
        self.movies = section.movies ?? []
    }
}
