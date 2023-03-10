//
//  TableViewHeaderFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

final class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    var viewModel: TableViewHeaderFooterViewViewModel!
    
    private lazy var titleLabel = createLabel()
    
    init(for section: Int, with viewModel: HomeViewModel) {
        super.init(reuseIdentifier: String(describing: TableViewHeaderFooterView.reuseIdentifier))
        self.viewModel = .init()
        self.viewDidConfigure(at: section, with: viewModel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
        label.font = font
        label.textColor = .white
        contentView.addSubview(label)
        label.constraintBottom(toParent: self, withLeadingAnchor: 8.0)
        return label
    }
    
    private func viewDidConfigure(at index: Int, with homeViewModel: HomeViewModel) {
        backgroundView = .init()
        backgroundView?.backgroundColor = .black
        
        titleLabel.text = viewModel.title(homeViewModel.sections, forHeaderAt: index)
    }
}
