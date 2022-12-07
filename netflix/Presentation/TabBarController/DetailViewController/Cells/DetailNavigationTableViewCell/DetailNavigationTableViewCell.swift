//
//  DetailNavigationTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailNavigationTableViewCell: UITableViewCell {
    fileprivate(set) var navigationView: DetailNavigationView!
    
    init(with viewModel: DetailViewModel) {
        super.init(style: .default, reuseIdentifier: DetailNavigationTableViewCell.reuseIdentifier)
        self.navigationView = DetailNavigationView(on: self.contentView, with: viewModel)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        navigationView = nil
    }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
