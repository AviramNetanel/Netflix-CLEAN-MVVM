//
//  DetailViewController.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var previewContainer: UIView!
    
    var viewModel: DetailViewModel!
    private(set) var previewView: PreviewView!
    private(set) var dataSource: DetailTableViewDataSource!
    
    deinit {
        viewModel.resetOrientation()
        removeObservers()
        previewView = nil
        dataSource = nil
        viewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupObservers()
    }
    
    private func setupSubviews() {
        setupPreviewView()
        setupDataSource()
    }
    
    private func setupObservers() {
        navigationViewState(in: viewModel)
        season(in: viewModel)
    }
    
    private func setupPreviewView() {
        previewView = PreviewView(on: previewContainer, with: viewModel)
    }
    
    private func setupDataSource() {
        let actions = DetailTableViewDataSourceActions(heightForRowAt: heightForRow())
        dataSource = DetailTableViewDataSource(on: tableView, actions: actions, with: viewModel)
    }
    
    func removeObservers() {
        if let viewModel = viewModel {
            printIfDebug("Removed `DetailViewModel` observers.")
            viewModel.navigationViewState.remove(observer: self)
            viewModel.season.remove(observer: self)
        }
    }
}

extension DetailViewController {
    private func navigationViewState(in viewModel: DetailViewModel) {
        viewModel.navigationViewState.observe(on: self) { [weak self] state in
            self?.dataSource?.collectionCell?.detailCollectionView?.dataSourceDidChange()
            self?.tableView.reloadData()
        }
    }
    
    private func season(in viewModel: DetailViewModel) {
        viewModel.season.observe(on: self) { [weak self] season in
            self?.dataSource?.collectionCell?.detailCollectionView?.dataSourceDidChange()
            self?.tableView.reloadData()
        }
    }
}

extension DetailViewController {
    func heightForRow() -> (IndexPath) -> CGFloat {
        return { [weak self] indexPath in
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
                case .episodes, .trailers:
                    return CGFloat(self.dataSource.contentSize(with: self.viewModel.navigationViewState.value))
                default:
                    return CGFloat(self.dataSource.contentSize(with: self.viewModel.navigationViewState.value))
                }
            }
        }
    }
}
