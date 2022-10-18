//
//  DetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func dataDidLoad<T>(response: T)
    func viewDidLoad()
    func contentSize(with state: DetailNavigationView.State) -> Float
    func getSeason(with viewModel: EpisodeCollectionViewCellViewModel,
                   completion: @escaping () -> Void)
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var detailUseCase: DetailUseCase! { get }
    var task: Cancellable? { get }
    var section: Section! { get }
    var media: Media! { get }
    var state: TableViewDataSource.State! { get }
    var navigationViewState: Observable<DetailNavigationView.State>! { get }
    var season: Observable<Season?>! { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailViewModel class

final class DetailViewModel: ViewModel {
    
    var detailUseCase: DetailUseCase!
    var task: Cancellable? { willSet { task?.cancel() } }
    
    var section: Section!
    var media: Media!
    var state: TableViewDataSource.State!
    
    var navigationViewState: Observable<DetailNavigationView.State>! = .init(.episodes)
    var season: Observable<Season?>! = .init(nil)
    
    deinit {
        season.value = nil
        state = nil
        media = nil
        section = nil
        task = nil
    }
    
    static func create(detailUseCase: DetailUseCase) -> DetailViewModel {
        let viewModel = DetailViewModel()
        viewModel.detailUseCase = detailUseCase
        return viewModel
    }
    
    fileprivate func dataDidLoad<T>(response: T) {
        switch response {
        case let response as SeasonResponse:
            season.value = response.data
        default: break
        }
    }
    
    func viewDidLoad() {}
    
    func contentSize(with state: DetailNavigationView.State) -> Float {
        switch state {
        case .episodes:
            guard let season = season.value as Season? else { return .zero }
            let cellHeight = Float(156.0)
            let lineSpacing = Float(8.0)
            let itemsCount = Float(season.episodes.count)
            let value = cellHeight * itemsCount + (lineSpacing * itemsCount)
            return Float(value)
        case .trailers:
            guard let trailers = media.resources.trailers as [String]? else { return .zero }
            let cellHeight = Float(224.0)
            let lineSpacing = Float(8.0)
            let itemsCount = Float(trailers.count)
            let value = cellHeight * itemsCount + (lineSpacing * itemsCount)
            return Float(value)
        default:
            let cellHeight = Float(146.0)
            let lineSpacing = Float(8.0)
            let itemsPerLine = Float(3.0)
            let topContentInset = Float(16.0)
            let itemsCount = self.state == .tvShows
                ? Float(section.media.count)
                : Float(section.media.count)
            let roundedItemsOutput = (itemsCount / itemsPerLine).rounded(.awayFromZero)
            let value =
                roundedItemsOutput * cellHeight
                + lineSpacing * roundedItemsOutput
                + topContentInset
            return Float(value)
        }
    }
    
    func getSeason(with viewModel: EpisodeCollectionViewCellViewModel,
                   completion: @escaping () -> Void) {
        task = detailUseCase.execute(for: SeasonResponse.self,
                                     with: viewModel) { [weak self] result in
            switch result {
            case .success(let response):
                self?.dataDidLoad(response: response)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
