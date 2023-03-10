//
//  DetailInfoTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailInfoTableViewCell: UITableViewCell {
    init(with viewModel: DetailViewModel) {
        super.init(style: .default, reuseIdentifier: DetailInfoTableViewCell.reuseIdentifier)
        let viewModel = DetailInfoViewViewModel(with: viewModel)
        let infoView = DetailInfoView(on: self.contentView, with: viewModel)
        self.contentView.addSubview(infoView)
        infoView.constraintToSuperview(self.contentView)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
