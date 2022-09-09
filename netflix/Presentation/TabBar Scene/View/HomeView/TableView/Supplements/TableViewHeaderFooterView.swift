//
//  TableViewHeaderFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - TitleHeaderView

final class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    private(set) var titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    static func create(tableView: UITableView,
                       viewModel: HomeViewModel,
                       at section: Int) -> TableViewHeaderFooterView {
        tableView.register(TableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.reuseIdentifier)
        
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TableViewHeaderFooterView.reuseIdentifier) as? TableViewHeaderFooterView
        else {
            fatalError("Could not dequeue tableView reusable view of \(TableViewHeaderFooterView.self) with reuseIdentifier: \(TableViewHeaderFooterView.reuseIdentifier)")
        }
        let title = viewModel.titleForHeader(at: section)
        let font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
        header.titleLabel.text = title
        header.titleLabel.font = font
        return header
    }
    
    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
    }
}

// MARK: - Configurable implementation

extension TableViewHeaderFooterView: Configurable {}
