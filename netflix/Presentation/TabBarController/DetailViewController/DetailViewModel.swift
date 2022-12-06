//
//  DetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

//// MARK: - ViewModelInput protocol
//
//private protocol ViewModelInput {
//    func viewDidLoad()
//    func contentSize(with state: DetailNavigationView.State) -> Float
//    func getSeason(with request: SeasonRequestDTO.GET, completion: @escaping () -> Void)
//}
//
//// MARK: - ViewModelOutput protocol
//
//private protocol ViewModelOutput {
//    var task: Cancellable? { get }
//    var dependencies: DetailViewModel.Dependencies { get }
//    var homeDataSourceState: HomeTableViewDataSource.State! { get }
//    var navigationViewState: Observable<DetailNavigationView.State>! { get }
//    var season: Observable<Season?>! { get }
//    var myList: MyList! { get }
//    var myListSection: Section! { get }
//}
//
//// MARK: - ViewModel typealias
//
//private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailViewModel class

final class DetailViewModel: ViewModel {

    let useCase: DetailUseCase
    let section: Section
    let media: Media
    
    var coordinator: DetailViewCoordinator?
    
    fileprivate var task: Cancellable? { willSet { task?.cancel() } }
    fileprivate(set) var homeDataSourceState: HomeTableViewDataSource.State!
    fileprivate(set) var navigationViewState: Observable<DetailNavigationView.State>! = Observable(.episodes)
    fileprivate(set) var season: Observable<Season?>! = Observable(nil)
    fileprivate(set) var myList: MyList!
    fileprivate(set) var myListSection: Section!
    
    init(useCase: DetailUseCase, section: Section, media: Media, with viewModel: HomeViewModel) {
        self.useCase = useCase
        self.section = section
        self.media = media
        self.homeDataSourceState = viewModel.tableViewState.value
        self.myList = viewModel.myList
        self.myListSection = viewModel.myList.section
    }
    
    deinit {
        myList = nil
        myListSection = nil
        season.value = nil
        navigationViewState = nil
        homeDataSourceState = nil
        task = nil
    }
    
    func transform(input: Void) {}
    
    func getSeason(with request: SeasonRequestDTO.GET, completion: @escaping () -> Void) {
        task = useCase.execute(for: SeasonResponse.self,
                               with: request) { [weak self] result in
            if case let .success(responseDTO) = result {
                self?.season.value = responseDTO.data
                completion()
            }
            if case let .failure(error) = result { print(error) }
        }
    }
}
