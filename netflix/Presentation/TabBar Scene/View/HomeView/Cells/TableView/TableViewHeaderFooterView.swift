//
//  TableViewHeaderFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - TableViewHeaderFooterView class

final class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
        label.font = font
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static func create(in tableView: UITableView,
                       for section: Int,
                       with viewModel: HomeViewModel) -> TableViewHeaderFooterView? {
        guard
            let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: TableViewHeaderFooterView.reuseIdentifier) as? TableViewHeaderFooterView
        else { return nil }
        let title = String(describing: viewModel.sections.value[section].title)
        view.titleLabel.text = title
        view.backgroundView = .init()
        view.backgroundView!.backgroundColor = .black
        return view
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.constraintSubviews()
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
