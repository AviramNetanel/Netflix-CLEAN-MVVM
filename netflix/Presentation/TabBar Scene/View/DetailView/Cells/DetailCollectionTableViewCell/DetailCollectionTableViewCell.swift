//
//  DetailCollectionTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var detailCollectionView: DetailCollectionView! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailCollectionTableViewCell class

final class DetailCollectionTableViewCell: UITableViewCell, View {
    
    fileprivate(set) var detailCollectionView: DetailCollectionView!
    
    init(using diProvider: DetailViewDIProvider) {
        super.init(style: .default, reuseIdentifier: DetailCollectionTableViewCell.reuseIdentifier)
        self.detailCollectionView = DetailCollectionView(on: self.contentView, with: diProvider.dependencies.detailViewModel)
        self.contentView.addSubview(self.detailCollectionView)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit { detailCollectionView = nil }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
