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
    
    private(set) var dataSource: TableViewDataSource! = nil
    
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
        dataSource = .init(in: tableView, with: viewModel)
    }
    
    // MARK: Bindings
    
    private func bind(to viewModel: DefaultHomeViewModel) {
        viewModel.sections.observe(on: self) { [weak self] _ in
            guard let self = self else { return }
            self.setupDataSource()
            self.bind(to: self.dataSource)
        }
    }
    
    private func bind(to dataSource: TableViewDataSource) {
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
    
    func register<T: UITableViewHeaderFooterView>(headerFooter type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(class type: T.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(nib type: T.Type) {
        register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func register(_ identifiers: [String]) {
        for identifier in identifiers {
            register(.init(nibName: identifier, bundle: nil),
                    forCellReuseIdentifier: identifier)
        }
    }
}
