//
//  DetailNavigationTableViewCell.swift
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
    var navigationView: DetailNavigationView! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailNavigationTableViewCell class

final class DetailNavigationTableViewCell: UITableViewCell, View {
    
    fileprivate(set) var navigationView: DetailNavigationView!
    
    init(using diProvider: DetailViewDIProvider, for indexPath: IndexPath) {
        super.init(style: .default, reuseIdentifier: DetailNavigationTableViewCell.reuseIdentifier)
        self.navigationView = DetailNavigationView(on: self.contentView, with: diProvider.dependencies.detailViewModel)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit { navigationView = nil }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}

