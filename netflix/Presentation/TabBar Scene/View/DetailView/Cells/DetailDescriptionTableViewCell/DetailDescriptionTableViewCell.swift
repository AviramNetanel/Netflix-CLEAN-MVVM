//
//  DetailDescriptionTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

//// MARK: - ViewInput protocol
//
//private protocol ViewInput {
//    func viewDidConfigure()
//}
//
//// MARK: - ViewOutput protocol
//
//private protocol ViewOutput {}
//
//// MARK: - View typealias
//
//private typealias View = ViewInput & ViewOutput

// MARK: - DetailDescriptionTableViewCell class

final class DetailDescriptionTableViewCell: UITableViewCell {
    
    init(with viewModel: DetailViewModel) {
        super.init(style: .default, reuseIdentifier: DetailDescriptionTableViewCell.reuseIdentifier)
        let viewModel = DetailDescriptionViewViewModel(with: viewModel.media)
        let descriptionView = DetailDescriptionView(on: self.contentView, with: viewModel)
        self.contentView.addSubview(descriptionView)
        descriptionView.constraintToSuperview(self.contentView)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
