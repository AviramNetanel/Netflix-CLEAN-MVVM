//
//  TableViewHeaderFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(at index: Int,
                          with viewModel: HomeViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var titleLabel: UILabel { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - TableViewHeaderFooterView class

final class TableViewHeaderFooterView: UITableViewHeaderFooterView, View {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
        label.font = font
        label.textColor = .white
        contentView.addSubview(label)
        label.constraintBottom(toParent: self, withLeadingAnchor: 8.0)
        return label
    }()
    
    static func create(in tableView: UITableView,
                       for section: Int,
                       with viewModel: HomeViewModel) -> TableViewHeaderFooterView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: TableViewHeaderFooterView.reuseIdentifier) as? TableViewHeaderFooterView
        else { return nil }
        view.viewDidConfigure(at: section, with: viewModel)
        return view
    }
    
    fileprivate func viewDidConfigure(at index: Int,
                                      with viewModel: HomeViewModel) {
        backgroundView = .init()
        backgroundView?.backgroundColor = .black
        
        let title = String(describing: viewModel.sections.value[index].title)
        titleLabel.text = title
    }
}
