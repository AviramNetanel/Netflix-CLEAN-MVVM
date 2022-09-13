//
//  TableViewSnapshot.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - TableViewSnapshot

final class TableViewSnapshot: NSObject {
    
    // MARK: State

    @objc enum State: Int {
        case tvShows, movies, detail
    }
    
    
    // MARK: Properties
    
    private(set) var tableView: UITableView
    var sections: [Section]
    
    private var ratableCell: RatableTableViewCell! = nil
    private var resumableCell: ResumableTableViewCell! = nil
    private var standardCell: StandardTableViewCell! = nil
    
    var viewModel: DefaultHomeViewModel!
    
    var heightForRowAt: ((IndexPath) -> CGFloat)?
    
    init(_ state: TableViewSnapshot.State, _ tableView: UITableView, _ viewModel: DefaultHomeViewModel) {
        self.viewModel = viewModel
        self.tableView = tableView
        self.sections = viewModel.sections.value
        
        super.init()
        
        tableViewDidRegisterCells(tableView)
        tableViewDidChangeSnapshot(tableView)
    }
    
    deinit {
        ratableCell = nil
        resumableCell = nil
        standardCell = nil
        viewModel = nil
    }
}


extension TableViewSnapshot {
    
    func tableViewDidChangeSnapshot(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    func tableViewDidRegisterCells(_ tableView: UITableView) {
        tableView.register(TitleHeaderView.self)
        
        tableView.register(class: RatableTableViewCell.self)
        tableView.register(class: ResumableTableViewCell.self)
        
        for identifier in StandardTableViewCell.Identifier.allCases {
            tableView.register(StandardTableViewCell.self,
                               forCellReuseIdentifier: identifier.stringValue)
        }
    }
    
    func tableView(_ tableView: UITableView, willConfigure cell: UITableViewCell, at indexPath: IndexPath) {
        guard
            let viewModel = viewModel,
            let indices = SectionIndices(rawValue: indexPath.section),
            let section = sections[indices.rawValue] as Section?
        else {
            fatalError()
        }
        
        switch cell {
        case let cell as RatableTableViewCell:
            cell.configure(section, with: viewModel)
        case let cell as ResumableTableViewCell:
            cell.configure(section, with: viewModel)
        case let cell as StandardTableViewCell:
            cell.configure(section, with: viewModel)
        default: return
        }
    }
    
    func typeForRow(in section: Int) -> UITableViewCell.Type {
        guard let indices = SectionIndices(rawValue: section) else { return UITableViewCell.self }
        switch indices {
        case .ratable: return RatableTableViewCell.self
        case .resumable: return ResumableTableViewCell.self
        default: return StandardTableViewCell.self
        }
    }
    
    func tableViewDidShow(_ tableView: UITableView) {
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            self.tableView.alpha = .shown
        }
    }

    func tableViewDidHide(_ tableView: UITableView) {
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.tableView.alpha = .hidden
        }
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource Implementation

extension TableViewSnapshot: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let indices = SectionIndices(rawValue: indexPath.section),
            let type = typeForRow(in: indices.rawValue) as UITableViewCell.Type?
        else {
            fatalError()
        }
        switch indices {
        case .display:
            return .init()
        case .ratable:
            ratableCell = tableView.dequeueCell(for: type, at: indexPath)! as? RatableTableViewCell
            return ratableCell
        case .resumable:
            resumableCell = tableView.dequeueCell(for: type, at: indexPath)! as? ResumableTableViewCell
            return resumableCell
        default:
            let identifier = StandardTableViewCell.Identifier(rawValue: indices.rawValue)!
            standardCell = tableView.dequeueReusableCell(withIdentifier: identifier.stringValue, for: indexPath) as? StandardTableViewCell
            return standardCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRowAt!(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView.reuseIdentifier) as? TitleHeaderView,
            let indices = SectionIndices(rawValue: section)
        else { return nil }
        let title = "\(sections[indices.rawValue].title)"
        let font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
        header.titleLabel.text = title
        header.titleLabel.font = font
        header.backgroundView = UIView()
        header.backgroundView?.backgroundColor = .black
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let indices = SectionIndices(rawValue: section) else { return .zero }
        switch indices {
        case .display: return 0.0
        case .ratable: return 28.0
        default: return 24.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableView(tableView, willConfigure: cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let indices = SectionIndices(rawValue: indexPath.section) else { return }
        switch indices {
        case .display: break
        case .ratable: ratableCell = nil
        case .resumable: resumableCell = nil
        default: standardCell = nil
        }
    }
}


// MARK: - UITableViewDataSourcePrefetching Implementation

extension TableViewSnapshot: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}
}


// MARK: - UIScrollViewDelegate Implementation

extension TableViewSnapshot {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}
