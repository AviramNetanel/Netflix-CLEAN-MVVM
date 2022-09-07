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
    
    func reload() {
        tableView.reloadData()
    }
    
    // MARK: Private
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupViews() {
        
    }
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.sections.observe(on: self) { [weak self] _ in self?.reload() }
//        viewModel.items.observe(on: self) { [weak self] _ in self?.reload() }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandardItemTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? StandardItemTableViewCell else {
            fatalError("Cannot dequeue reusable cell \(StandardItemTableViewCell.self) with reuseIdentifier: \(StandardItemTableViewCell.reuseIdentifier)")
        }
        cell.fill(with: .init(section: viewModel.sections.value[indexPath.row]))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
