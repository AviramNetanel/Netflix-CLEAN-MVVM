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
    @IBOutlet private weak var previewContainer: UIView!
    
    var viewModel: DetailViewModel!
    private(set) var dataSource: DetailTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupBindings()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    static func create(with viewModel: DetailViewModel) -> DetailViewController {
        let view = Storyboard(withOwner: HomeTabBarController.self,
                              launchingViewController: DetailViewController.self)
            .instantiate() as! DetailViewController
        view.viewModel = viewModel
        return view
    }
    
    deinit {
        removeObservers()
        dataSource = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        setupPreviewView()
        setupDataSource()
    }
    
    private func setupBindings() {
        heightForRow(in: dataSource)
    }
    
    private func setupObservers() {
        navigationViewState(in: viewModel)
        season(in: viewModel)
    }
    
    private func setupPreviewView() {
        let previewView = PreviewView.create(on: previewContainer, with: viewModel)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.constraintToSuperview(previewContainer)
    }
    
    private func setupDataSource() {
        dataSource = .init(tableView: tableView, viewModel: viewModel)
        tableView.register(class: DetailInfoTableViewCell.self)
        tableView.register(class: DetailDescriptionTableViewCell.self)
        tableView.register(class: DetailPanelTableViewCell.self)
        tableView.register(class: DetailNavigationTableViewCell.self)
        tableView.register(class: DetailCollectionTableViewCell.self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    func removeObservers() {
        if let viewModel = viewModel {
            print("Removed `DetailViewModel` observers.")
            viewModel.navigationViewState.remove(observer: self)
            viewModel.season.remove(observer: self)
        }
        if let panelView = dataSource.panelCell.panelView {
            print("Removed `DetailPanelViewItem` observers.")
            panelView.leadingItem.viewModel.removeObservers()
            panelView.centerItem.viewModel.removeObservers()
            panelView.trailingItem.viewModel.removeObservers()
        }
    }
}

// MARK: - Bindings

extension DetailViewController {
    
    // MARK: DetailTableViewDataSource bindings
    
    private func heightForRow(in dataSource: DetailTableViewDataSource) {
        dataSource.heightForRow = { [weak self] indexPath in
            guard
                let self = self,
                let index = DetailTableViewDataSource.Index(rawValue: indexPath.section)
            else { return .zero }
            switch index {
            case .info: return self.view.bounds.height * 0.21
            case .description: return self.view.bounds.height * 0.135
            case .panel: return self.view.bounds.height * 0.0764
            case .navigation: return self.view.bounds.height * 0.0764
            case .collection:
                switch self.viewModel.navigationViewState.value {
                case .episodes,
                        .trailers:
                    return CGFloat(self.viewModel.contentSize(
                        with: self.viewModel.navigationViewState.value))
                default: return CGFloat(self.viewModel.contentSize(with: self.viewModel.navigationViewState.value))
                }
            }
        }
    }
}

// MARK: - Observers

extension DetailViewController {
    
    // MARK: DetailViewModel observers
    
    private func navigationViewState(in viewModel: DetailViewModel) {
        viewModel.navigationViewState.observe(on: self) { [weak self] state in
            self?.dataSource?.collectionCell?.detailCollectionView?.setupDataSource()
            self?.heightForRow(in: self!.dataSource)
        }
    }
    
    private func season(in viewModel: DetailViewModel) {
        viewModel.season.observe(on: self) { [weak self] season in
            self?.dataSource?.collectionCell?.detailCollectionView?.setupDataSource()
            self?.heightForRow(in: self!.dataSource)
        }
    }
}
