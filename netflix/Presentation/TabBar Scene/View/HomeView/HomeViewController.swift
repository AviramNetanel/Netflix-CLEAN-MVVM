//
//  HomeViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - HomeViewController class

final class HomeViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    var viewModel: DefaultHomeViewModel!
    
    private(set) var snapshot: TableViewSnapshot! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    static func create(with viewModel: DefaultHomeViewModel) -> HomeViewController {
        let view = UIStoryboard(name: String(describing: HomeTabBarController.self),
                                bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as! HomeViewController
        view.viewModel = viewModel
        return view
    }
    
    // MARK: Private
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupViews() {
        setupDataSource()
    }
    
    private func setupDataSource() {
        
    }
    
    // MARK: Bindings
    
    private func bind(to viewModel: DefaultHomeViewModel) {
        viewModel.sections.observe(on: self) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.snapshot = TableViewSnapshot(.tvShows, self.tableView, viewModel)
                self.tableView.delegate = self.snapshot
                self.tableView.dataSource = self.snapshot
                self.tableView.prefetchDataSource = self.snapshot
                self.tableView.reloadData()
                self.bind(to: self.snapshot)
            }
        }
    }
    
    private func bind(to dataSource: TableViewSnapshot) {
        dataSource.heightForRowAt = { [weak self] indexPath in
            guard
                let indices = SectionIndices(rawValue: indexPath.section),
                let self = self
            else { return .zero }
            switch indices {
            case .display: return self.view.bounds.height * 0.76
            default: return self.view.bounds.height * 0.18
            }
        }
    }
}

// MARK: - SectionIndices

enum SectionIndices: Int, Valuable, CaseIterable {
    
    case display,
         ratable,
         resumable,
         action,
         sciFi,
         blockbuster,
         myList,
         crime,
         thriller,
         adventure,
         comedy,
         drama,
         horror,
         anime,
         familyNchildren,
         documentary
    
    var stringValue: String {
        switch self {
        case .display,
                .ratable,
                .resumable,
                .myList:
            return ""
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .blockbuster: return "Blockbusters"
        case .crime: return "Crime"
        case .thriller: return "Thriller"
        case .adventure: return "Adventure"
        case .comedy: return "Comedy"
        case .drama: return "Drama"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}

// MARK: - CGFloat

extension CGFloat {
    static var hidden = 0.0
    static var shown = 1.0
}


// MARK: - UITableViewHeaderFooterView

extension UITableViewHeaderFooterView: Reusable {}

// MARK: - UITableViewCell

extension UITableViewCell: Reusable {}

// MARK: - UICollectionViewCell

extension UICollectionViewCell: Reusable {}

// MARK: - UITableView

extension UITableView {
    
    func register<T: UITableViewCell>(class cell: T.Type) {
        self.register(cell, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(nib cell: T.Type) {
        self.register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func register(_ identifiers: [String]) {
        for identifier in identifiers {
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    
    func register<T: UITableViewHeaderFooterView>(_ headerFooterType: T.Type) {
        self.register(headerFooterType, forHeaderFooterViewReuseIdentifier: headerFooterType.reuseIdentifier)
    }
    
    
    func dequeueCell<T>(for cell: T.Type,
                        as identifier: StandardTableViewCell.Identifier? = nil,
                        at indexPath: IndexPath) -> UITableViewCell?
    where T: UITableViewCell {
        let identifier = identifier != nil ? identifier!.stringValue : cell.reuseIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell \(cell.reuseIdentifier)")
        }
        return cell
    }
}
