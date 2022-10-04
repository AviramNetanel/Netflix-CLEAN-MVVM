//
//  DetailViewController.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import UIKit

// MARK: - DetailViewController class

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: DetailViewModel!
    
    private var dataSource: DetailTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupBindings()
    }
    
    static func create(with viewModel: DetailViewModel) -> DetailViewController {
        let view = UIStoryboard(name: String(describing: HomeTabBarController.self),
                                bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
        view.viewModel = viewModel
        return view
    }
    
    deinit {
        dataSource = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        setupDataSource()
    }
    
    private func setupBindings() {
        heightForRow(in: dataSource)
    }
    
    private func setupDataSource() {
        dataSource = .init(viewModel: viewModel, tableView: tableView)
        tableView.register(class: DetailPreviewTableViewCell.self)
        tableView.register(class: DetailInfoTableViewCell.self)
        tableView.register(class: DetailDescriptionTableViewCell.self)
        tableView.register(class: DetailPanelTableViewCell.self)
        tableView.register(class: DetailNavigationTableViewCell.self)
        tableView.register(class: DetailCollectionTableViewCell.self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

// MARK: - Bindings

extension DetailViewController {
    
    private func heightForRow(in dataSource: DetailTableViewDataSource) {
        dataSource.heightForRow = { [weak self] indexPath in
            guard
                let self = self,
                let index = DetailTableViewDataSource.Index(rawValue: indexPath.section)
            else { return .zero }
            switch index {
            case .preview:
                return self.view.bounds.height * 0.279
            case .info:
                return 176.0
            case .description:
                return 112.0
            case .panel:
                return 48.0
            case .navigation:
                return 44.0
            case .collection:
                let section = self.viewModel.section!
                let value = (Float(section.tvshows!.count) / 3.0).rounded(.awayFromZero) * 138.0 + (8.0 * Float(section.tvshows!.count) / 3.0).rounded(.awayFromZero)
                return CGFloat(value)
            }
        }
    }
}
