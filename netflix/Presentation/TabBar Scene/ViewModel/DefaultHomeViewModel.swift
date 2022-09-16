//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - HomeViewModelActions struct

struct HomeViewModelActions {
    let presentMediaDetails: (Media) -> Void
}

// MARK: - HomeViewModelEndpoints

private protocol HomeViewModelEndpoints {
    func getSections()
    func getTVShows()
    func getMovies()
}

// MARK: - HomeViewModelInput protocol

private protocol HomeViewModelInput {
    func viewDidLoad()
    func dataDidLoad(response: SectionsResponse)
    func filter(sections: [Section])
    func filter(sections: [Section], at index: Int)
    func filter(sections: [Section], at index: Int, withMinimumRating value: Float)
    func section(at index: DefaultTableViewDataSource.Indices) -> Section
    func randomObject(at section: Section) -> Media?
    func titleForHeader(at index: Int) -> String
    func didSelectItem(at index: Int)
}

// MARK: - HomeViewModelOutput protocol

private protocol HomeViewModelOutput {
    var state: Observable<DefaultTableViewDataSource.State> { get }
    var sections: Observable<[Section]> { get }
    var isEmpty: Bool { get }
}

// MARK: - HomeViewModel protocol

private protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput, HomeViewModelEndpoints {}

// MARK: - HomeViewModel class

final class DefaultHomeViewModel: HomeViewModel {
    
    private let homeUseCase: HomeUseCase
    private let actions: HomeViewModelActions
    
    private var task: Cancellable? { willSet { task?.cancel() } }
    
    fileprivate(set) var state: Observable<DefaultTableViewDataSource.State> = Observable(.tvShows)
    fileprivate(set) var sections: Observable<[Section]> = Observable([])
    fileprivate var isEmpty: Bool { return sections.value.isEmpty }
    
    init(homeUseCase: HomeUseCase,
         actions: HomeViewModelActions) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
    
    deinit {
        task = nil
    }
    
    func removeObservers() {
        print("Removed `DefaultHomeViewModel` observers.")
        state.remove(observer: self)
    }
}

// MARK: - HomeViewModelInput implementation

extension DefaultHomeViewModel {
    
    func viewDidLoad() {
        getSections()
    }
    
    func dataDidLoad(response: SectionsResponse) {
        sections.value = response.data
        filter(sections: sections.value)
        state.value = .tvShows
    }
    
    func filter(sections: [Section]) {
        for i in DefaultTableViewDataSource.Indices.allCases {
            switch i {
            case .ratable,
                    .resumable:
                sections[i.rawValue].tvshows = sections.first!.tvshows
                sections[i.rawValue].movies = sections.first!.movies
            case .action, .sciFi,
                    .crime, .thriller,
                    .adventure, .comedy,
                    .drama, .horror,
                    .anime, .familyNchildren,
                    .documentary:
                filter(sections: sections, at: i.rawValue)
            case .blockbuster:
                filter(sections: sections, at: i.rawValue, withMinimumRating: 7.5)
            default: break
            }
        }
    }

    func filter(sections: [Section], at index: Int) {
        sections[index].tvshows = sections.first!.tvshows!.filter {
            $0.genres.contains(sections[index].title)
        }
        sections[index].movies = sections.first!.movies!.filter {
            $0.genres.contains(sections[index].title)
        }
    }
    
    func filter(sections: [Section], at index: Int, withMinimumRating value: Float) {
        sections[index].tvshows = sections.first!.tvshows!.filter { $0.rating > value }
        sections[index].movies = sections.first!.movies!.filter { $0.rating > value }
    }
    
    func section(at index: DefaultTableViewDataSource.Indices) -> Section {
        return sections.value[index.rawValue]
    }
    
    func randomObject(at section: Section) -> Media? {
        guard
            let media = state.value == .tvShows
                ? section.tvshows!.randomElement()
                : section.movies!.randomElement()
        else { return nil }
        return media
    }
    
    func titleForHeader(at index: Int) -> String {
        return .init(describing: sections.value[index].title)
    }
    
    func didSelectItem(at index: Int) {}
}

// MARK: - HomeViewModelEndpoints implementation

fileprivate extension DefaultHomeViewModel {
    
    func getSections() {
        task = homeUseCase.executeSections { [weak self] result in
            guard let self = self else { return }
            if case let .success(response) = result { self.dataDidLoad(response: response) }
        }
    }
    
    func getTVShows() {
        task = homeUseCase.executeTVShows { _ in }
    }
    
    func getMovies() {
        task = homeUseCase.executeMovies { _ in }
    }
}
