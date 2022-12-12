//
//  DetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

final class DetailViewModel: ViewModel {
    var coordinator: DetailViewCoordinator?
    let useCase: DetailUseCase
    let section: Section
    var media: Media
    let orientation = DeviceOrientation.shared
    
    var isRotated: Bool? {
        didSet { shouldScreenRotate() }
    }
    private(set) var homeDataSourceState: HomeTableViewDataSource.State!
    private(set) var navigationViewState: Observable<DetailNavigationView.State>! = Observable(.episodes)
    private(set) var season: Observable<Season?>! = Observable(nil)
    private(set) var myList: MyList!
    private(set) var myListSection: Section!
    private var task: Cancellable? {
        willSet { task?.cancel() }
    }
    
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
        isRotated = nil
        myList = nil
        myListSection = nil
        season.value = nil
        navigationViewState = nil
        homeDataSourceState = nil
        task = nil
    }
    
    func transform(input: Void) {}
    
    private func shouldScreenRotate() {
        orientation.setLock(orientation: .all)
        
        if isRotated ?? false {
            asynchrony(dispatchingDelayInSeconds: 1) { [weak orientation] in
                orientation?.set(orientation: .landscapeLeft)
            }
        }
    }
    
    func resetOrientation() {
        orientation.setLock(orientation: .portrait)
    }
    
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
