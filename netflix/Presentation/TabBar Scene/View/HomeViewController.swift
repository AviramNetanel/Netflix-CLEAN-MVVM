//
//  HomeTableViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - HomeTableViewController class

final class HomeViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        viewModel.viewDidLoad()
        bind(to: viewModel)
        setupTableView()
    }
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let view = HomeViewController.instantiateViewController()
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
    
    private func setupTableView() {
        tableView.estimatedRowHeight = StandardItemTableViewCell.height
        tableView.rowHeight = UITableView.automaticDimension
        
        viewModel.getTVShows { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.viewModel.items.value = response.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.reload() }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource implementation

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandardItemTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? StandardItemTableViewCell else {
            fatalError("Cannot dequeue reusable cell \(StandardItemTableViewCell.self) with reuseIdentifier: \(StandardItemTableViewCell.reuseIdentifier)")
        }
        cell.fill(with: .init(media: viewModel.items.value[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
