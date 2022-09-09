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
    
    var viewModel: HomeViewModel!
    private var dataSource: DefaultTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
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
        dataSource = DefaultTableViewDataSource(tableView: tableView,
                                                state: .tvShows,
                                                viewModel: viewModel)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = dataSource
    }
    
    // MARK: Bindings
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.sections.observe(on: self) { [weak self] _ in
            guard let self = self else { return }
            self.dataSource.reload()
            self.bind(to: self.dataSource)
        }
    }
    
    private func bind(to dataSource: DefaultTableViewDataSource) {
        dataSource.heightForRowAt = { [weak self] indexPath in
            guard
                let indices = TableViewSection(rawValue: indexPath.section),
                let self = self
            else { return .zero }
            switch indices {
            case .display: return self.view.bounds.height * 0.76
            default: return self.view.bounds.height * 0.18
            }
        }
    }
}
