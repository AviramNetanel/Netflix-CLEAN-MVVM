//
//  HomeTableViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - HomeTableViewController class

final class HomeTableViewController: UITableViewController {
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    static func create(with viewModel: HomeViewModel) -> HomeTableViewController {
        let view = UIStoryboard(name: String(describing: HomeTabBarController.self),
                                bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: HomeTableViewController.self)) as! HomeTableViewController
        view.viewModel = viewModel
        return view
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    // MARK: Private
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = StandardItemTableViewCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.sections.observe(on: self) { [weak self] _ in self?.reload() }
        viewModel.items.observe(on: self) { [weak self] _ in self?.reload() }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandardItemTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? StandardItemTableViewCell else {
            fatalError("Cannot dequeue reusable cell \(StandardItemTableViewCell.self) with reuseIdentifier: \(StandardItemTableViewCell.reuseIdentifier)")
        }
        cell.fill(with: .init(section: viewModel.sections.value[indexPath.row]))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sections.value.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
