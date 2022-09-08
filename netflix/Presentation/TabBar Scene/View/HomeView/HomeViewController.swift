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
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.sections.observe(on: self) { [weak self] _ in self?.dataSource.reload() }
    }
    
    private func setupDataSource() {
        dataSource = DefaultTableViewDataSource(tableView: tableView,
                                                state: .tvShows,
                                                viewModel: viewModel)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = dataSource
    }
}
