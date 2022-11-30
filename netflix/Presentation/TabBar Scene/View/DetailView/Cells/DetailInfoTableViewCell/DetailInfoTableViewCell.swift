//
//  DetailInfoTableViewCell.swift
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

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailInfoTableViewCell class

final class DetailInfoTableViewCell: UITableViewCell, View {
    
    init(using diProvider: DetailViewDIProvider, for indexPath: IndexPath) {
        super.init(style: .default, reuseIdentifier: DetailInfoTableViewCell.reuseIdentifier)
        let infoView = DetailInfoView(on: self, with: diProvider.dependencies.detailViewModel)
        self.contentView.addSubview(infoView)
        infoView.constraintToSuperview(self.contentView)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
