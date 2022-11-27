//
//  TableViewHeaderFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(at index: Int, with viewModel: HomeViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var viewModel: TableViewHeaderFooterViewViewModel { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - TableViewHeaderFooterView class

final class TableViewHeaderFooterView: UITableViewHeaderFooterView, View {
    
    fileprivate let viewModel = TableViewHeaderFooterViewViewModel()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
        label.font = font
        label.textColor = .white
        contentView.addSubview(label)
        label.constraintBottom(toParent: self, withLeadingAnchor: 8.0)
        return label
    }()
    
    static func create(using homeSceneDependencies: HomeViewDIProvider,
                       for section: Int) -> TableViewHeaderFooterView? {
        guard let view = homeSceneDependencies.dependencies.tableView
            .dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.reuseIdentifier) as? TableViewHeaderFooterView
        else { return nil }
        view.viewDidConfigure(at: section, with: homeSceneDependencies.dependencies.homeViewModel)
        return view
    }
    
    fileprivate func viewDidConfigure(at index: Int, with homeViewModel: HomeViewModel) {
        backgroundView = .init()
        backgroundView?.backgroundColor = .black
        
        titleLabel.text = viewModel.title(homeViewModel.sections, forHeaderAt: index)
    }
}
