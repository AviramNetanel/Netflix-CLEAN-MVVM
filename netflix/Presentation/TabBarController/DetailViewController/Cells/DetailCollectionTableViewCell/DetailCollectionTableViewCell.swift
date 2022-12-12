//
//  DetailCollectionTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailCollectionTableViewCell: UITableViewCell {
    var detailCollectionView: DetailCollectionView!
    
    init(with viewModel: DetailViewModel) {
        super.init(style: .default, reuseIdentifier: DetailCollectionTableViewCell.reuseIdentifier)
        self.detailCollectionView = DetailCollectionView(on: self.contentView, with: viewModel)
        self.contentView.addSubview(self.detailCollectionView)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        detailCollectionView = nil
    }
    
    private func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
