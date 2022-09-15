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
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    var viewModel: DefaultHomeViewModel!
    
    private(set) var dataSource: DefaultTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupBindings()
        setupSubviews()
        viewModel.viewDidLoad()
    }
    
    static func create(with viewModel: DefaultHomeViewModel) -> HomeViewController {
        let view = UIStoryboard(name: String(describing: HomeTabBarController.self),
                                bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as! HomeViewController
        view.viewModel = viewModel
        return view
    }
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupSubviews() {
        setupDataSource()
    }
    
    private func setupBindings() {
        state(in: viewModel)
    }
    
    private func setupDataSource() {
        dataSource = .init(in: tableView, with: viewModel)
        heightForRowAt(in: dataSource)
    }
    
    private func state(in viewModel: DefaultHomeViewModel) {
        viewModel.state.observe(on: self) { [weak self] _ in self?.setupDataSource() }
    }
    
    private func heightForRowAt(in dataSource: DefaultTableViewDataSource) {
        dataSource.heightForRowAt = { [weak self] indexPath in
            guard let self = self else { return .zero }
            if case .display = DefaultTableViewDataSource.Indices(rawValue: indexPath.section) {
                return self.view.bounds.height * 0.76
            }
            return self.view.bounds.height * 0.18
        }
    }
}
