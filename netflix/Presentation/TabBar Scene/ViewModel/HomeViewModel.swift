//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - HomeViewModelActions struct

struct HomeViewModelActions {
    let presentMediaDetails: (MediaDTO) -> Void
}

// MARK: - HomeViewModelEndpoints

protocol HomeViewModelEndpoints {
    func getSections()
    func getTVShows()
    func getMovies()
}

// MARK: - HomeViewModelInput protocol

protocol HomeViewModelInput {
    func viewDidLoad()
    func didSelectItem(at index: Int)
}

// MARK: - HomeViewModelOutput protocol

protocol HomeViewModelOutput {
    var sections: Observable<[SectionDTO]> { get }
    var items: Observable<[MediaDTO]> { get }
    var isEmpty: Bool { get }
}

// MARK: - HomeViewModel protocol

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput, HomeViewModelEndpoints {}

// MARK: - HomeViewModel class

final class DefaultHomeViewModel: HomeViewModel {
    
    private let homeUseCase: HomeUseCase
    private let actions: HomeViewModelActions
    
    private var task: Cancellable? {
        willSet {
            task?.cancel()
        }
    }
    
    // MARK: Output
    
    var sections: Observable<[SectionDTO]> = Observable([])
    var items: Observable<[MediaDTO]> = Observable([])
    var isEmpty: Bool { return items.value.isEmpty }
    
    init(homeUseCase: HomeUseCase,
         actions: HomeViewModelActions) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
}

// MARK: - HomeViewModelInput implementation

extension DefaultHomeViewModel {
    
    func viewDidLoad() {
        getSections()
    }
    
    func didSelectItem(at index: Int) {
        
    }
}

// MARK: - HomeViewModelEndpoints implementation

extension DefaultHomeViewModel {
    
    func getSections() {
        task = homeUseCase.executeSections { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.sections.value = response.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTVShows() {
        task = homeUseCase.executeTVShows { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.items.value = response.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMovies() {
        task = homeUseCase.executeMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.items.value = response.data
            case .failure(let error):
                print(error)
            }
        }
    }
}
