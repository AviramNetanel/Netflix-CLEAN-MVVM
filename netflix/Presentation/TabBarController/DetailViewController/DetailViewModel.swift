//
//  DetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

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
    
    init(section: Section, media: Media, with viewModel: HomeViewModel) {
        let dataTransferService = Application.current.dataTransferService
        let repository = SeasonRepository(dataTransferService: dataTransferService)
        let useCase = DetailUseCase(seasonsRepository: repository)
        self.useCase = useCase
        self.section = section
        self.media = media
        self.homeDataSourceState = viewModel.tableViewState.value
        self.myList = viewModel.myList
        self.myListSection = viewModel.myList.viewModel.section
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
