//
//  TableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

class TableViewCell<Cell>: UITableViewCell, Configurable where Cell: UICollectionViewCell {
    
    enum SortOptions {
        case rating
    }
    
    var collectionView: UICollectionView!
    var section: Section!
    
    var dataSet: CollectionViewSnapshotDataSet<Cell>! = nil
    var snapshot: CollectionViewSnapshot<Cell, CollectionViewSnapshotDataSet<Cell>>! = nil
    
    var viewModel: DefaultHomeViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .black
        
        self.collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        self.collectionView.backgroundColor = .black
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.contentView.addSubview(collectionView)
        
        self.collectionView.register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        collectionView = nil
        section = nil
        viewModel = nil
    }
    
    //
    
    func configure(_ section: Section? = nil,
                   with viewModel: DefaultHomeViewModel? = nil) {
        
        if let viewModel = viewModel {
            self.viewModel = viewModel
            self.section = section
            
            let index = SectionIndices(rawValue: self.section.id)
            
            dataSet = .init(self.section, viewModel: viewModel)
            snapshot = .init(dataSet, viewModel)
            
            collectionView.delegate = snapshot
            collectionView.dataSource = snapshot
            collectionView.prefetchDataSource = snapshot
            collectionView.reloadData()
            
            switch index {
            case .display:
                break
            case .ratable:
                let layout = ComputableFlowLayout(.ratable)
                collectionView.setCollectionViewLayout(layout, animated: false)
            case .resumable:
                let layout = ComputableFlowLayout(.resumable)
                collectionView.setCollectionViewLayout(layout, animated: false)
            case .myList:
                break
            default:
                dataSet = .init(self.section, viewModel: viewModel, standardCell: self)
                snapshot = .init(dataSet, viewModel)
                
                collectionView.delegate = snapshot
                collectionView.dataSource = snapshot
                collectionView.prefetchDataSource = snapshot
                collectionView.reloadData()
                
                let layout = ComputableFlowLayout(.standard)
                collectionView.setCollectionViewLayout(layout, animated: false)
                
                return
            }
        }
    }
}
