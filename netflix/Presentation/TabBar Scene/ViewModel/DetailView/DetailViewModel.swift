//
//  DetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - DetailViewModelActions struct

struct DetailViewModelActions {}

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func viewDidLoad()
    func contentSize(with state: DetailNavigationView.State) -> Float
    func getSeason(with request: SeasonRequestDTO.GET,
                   completion: @escaping () -> Void)
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var task: Cancellable? { get }
    var dependencies: DetailViewModel.Dependencies { get }
    var state: HomeTableViewDataSource.State! { get }
    var navigationViewState: Observable<DetailNavigationView.State>! { get }
    var season: Observable<Season?>! { get }
    var myList: MyList! { get }
    var myListSection: Section! { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailViewModel class

final class DetailViewModel: ViewModel {

    struct Dependencies {
        let detailUseCase: DetailUseCase
        let section: Section
        let media: Media
        let viewModel: HomeViewModel
    }
    
    fileprivate var task: Cancellable? { willSet { task?.cancel() } }
    fileprivate(set) var dependencies: Dependencies
    fileprivate(set) var state: HomeTableViewDataSource.State!
    fileprivate(set) var navigationViewState: Observable<DetailNavigationView.State>! = Observable(.episodes)
    fileprivate(set) var season: Observable<Season?>! = Observable(nil)
    fileprivate(set) var myList: MyList!
    fileprivate(set) var myListSection: Section!
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.state = dependencies.viewModel.tableViewState.value
        self.myList = dependencies.viewModel.myList
        self.myListSection = dependencies.viewModel.myList.section
    }
    
    deinit {
        myList = nil
        myListSection = nil
        season.value = nil
        navigationViewState = nil
        state = nil
        task = nil
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
            guard let trailers = dependencies.media.resources.trailers as [String]? else { return .zero }
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
            let itemsCount = self.state == .series
                ? Float(dependencies.section.media.count)
                : Float(dependencies.section.media.count)
            let roundedItemsOutput = (itemsCount / itemsPerLine).rounded(.awayFromZero)
            let value =
                roundedItemsOutput * cellHeight
                + lineSpacing * roundedItemsOutput
                + topContentInset
            return Float(value)
        }
    }
    
    func getSeason(with request: SeasonRequestDTO.GET,
                   completion: @escaping () -> Void) {
        task = dependencies.detailUseCase.execute(for: SeasonResponse.self,
                                                  with: request) { [weak self] result in
            if case let .success(responseDTO) = result {
                self?.season.value = responseDTO.data
                completion()
            }
            if case let .failure(error) = result { print(error) }
        }
    }
}
