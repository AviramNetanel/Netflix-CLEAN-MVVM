//
//  DefaultTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - TableViewCellInput protocol

private protocol TableViewCellInput {
    func configure(section: Section, with viewModel: DefaultHomeViewModel)
}

// MARK: - TableViewCellOutput protocol

private protocol TableViewCellOutput {}

// MARK: - TableViewCell protocol

private protocol TableViewCell: TableViewCellInput, TableViewCellOutput {}

// MARK: - DefaultTableViewCell class

class DefaultTableViewCell<Cell>: UITableViewCell, TableViewCell where Cell: UICollectionViewCell {
    
    enum SortOptions {
        case rating
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        contentView.addSubview(collectionView)
        return collectionView
    }()
    
    private var dataSource: DefaultCollectionViewDataSource<Cell>!
    
    var viewModel: DefaultHomeViewModel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
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

// MARK: - TableViewCellInput implementation

extension DefaultTableViewCell {
    
    func configure(section: Section, with viewModel: DefaultHomeViewModel) {
        self.viewModel = viewModel
        
        guard let indices = DefaultTableViewDataSource.Indices(rawValue: section.id) else { return }
        
        dataSource = .init(collectionView: collectionView,
                           section: section,
                           viewModel: viewModel)
        
        guard !(collectionView.collectionViewLayout is ComputableFlowLayout) else { return }
        
        switch indices {
        case .display:
            break
        case .ratable:
            let layout = ComputableFlowLayout(.ratable)
            collectionView.setCollectionViewLayout(layout, animated: false)
        default:
            let layout = ComputableFlowLayout(.standard)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
}
