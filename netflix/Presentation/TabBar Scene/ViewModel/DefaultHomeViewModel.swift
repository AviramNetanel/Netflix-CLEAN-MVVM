//
//  DefaultHomeViewModel.swift
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
    func dataDidLoad(response: SectionsResponse, completion: @escaping () -> Void)
    func filter(sections: [Section])
    func filter(sections: [Section], at index: Int, withMinimumRating value: Float?)
    func section(at index: DefaultTableViewDataSource.Index) -> Section
    func title(forHeaderAt index: Int) -> String
    func randomObject(at section: Section) -> Media
    func presentedDisplayMediaDidChange()
    
//    var presentNavigationView: () -> Void { get }
}

// MARK: - HomeViewModelOutput protocol

private protocol HomeViewModelOutput {
    var state: Observable<DefaultTableViewDataSource.State> { get }
    var sections: Observable<[Section]> { get }
    var presentedDisplayMedia: Observable<Media?> { get }
    var isEmpty: Bool { get }
}

// MARK: - HomeViewModel protocol

private protocol HomeViewModel: HomeViewModelInput,
                                HomeViewModelOutput,
                                HomeViewModelEndpoints {}

// MARK: - HomeViewModel class

final class DefaultHomeViewModel: HomeViewModel {
    
    private let homeUseCase: HomeUseCase
    private let actions: HomeViewModelActions
    
    private var task: Cancellable? { willSet { task?.cancel() } }
    
    var presentNavigationView: (() -> Void)?
    
    fileprivate(set) var state: Observable<DefaultTableViewDataSource.State> = Observable(.tvShows)
    fileprivate(set) var sections: Observable<[Section]> = Observable([])
    private(set) var presentedDisplayMedia: Observable<Media?> = Observable(nil)
    fileprivate var isEmpty: Bool { return sections.value.isEmpty }
    
    init(homeUseCase: HomeUseCase,
         actions: HomeViewModelActions) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
    
    deinit {
        task = nil
    }
    
    private func present() {
        presentNavigationView?()
        // Main entry-point for tableview
        state.value = .tvShows
    }
}

// MARK: - HomeViewModelInput implementation

extension DefaultHomeViewModel {
    
    func viewDidLoad() {
        getSections()
    }
    
    func dataDidLoad(response: SectionsResponse, completion: @escaping () -> Void) {
        sections.value = response.data
        filter(sections: sections.value)
        
        completion()
    }
    
    func filter(sections: [Section]) {
        for index in DefaultTableViewDataSource.Index.allCases {
            switch index {
            case .ratable,
                    .resumable:
                sections[index.rawValue].tvshows = sections.first!.tvshows
                sections[index.rawValue].movies = sections.first!.movies
            case .action, .sciFi,
                    .crime, .thriller,
                    .adventure, .comedy,
                    .drama, .horror,
                    .anime, .familyNchildren,
                    .documentary:
                filter(sections: sections, at: index.rawValue)
            case .blockbuster:
                filter(sections: sections, at: index.rawValue, withMinimumRating: 7.5)
            default: break
            }
        }
    }
    
    func filter(sections: [Section],
                at index: Int,
                withMinimumRating value: Float? = nil) {
        guard let value = value else {
            sections[index].tvshows = sections.first!.tvshows!.filter {
                $0.genres.contains(sections[index].title)
            }
            sections[index].movies = sections.first!.movies!.filter {
                $0.genres.contains(sections[index].title)
            }
            return
        }
        sections[index].tvshows = sections.first!.tvshows!.filter { $0.rating > value }
        sections[index].movies = sections.first!.movies!.filter { $0.rating > value }
    }
    
    func section(at index: DefaultTableViewDataSource.Index) -> Section {
        return sections.value[index.rawValue]
    }
    
    func title(forHeaderAt index: Int) -> String {
        return .init(describing: sections.value[index].title)
    }
    
    func randomObject(at section: Section) -> Media {
        return state.value == .tvShows
            ? section.tvshows!.randomElement()!
            : section.movies!.randomElement()!
    }
    
    func presentedDisplayMediaDidChange() {
        let media = randomObject(at: section(at: .display))
        presentedDisplayMedia.value = media
    }
}

// MARK: - HomeViewModelEndpoints implementation

fileprivate extension DefaultHomeViewModel {
    
    func getSections() {
        task = homeUseCase.executeSections { [weak self] result in
            guard let self = self else { return }
            if case let .success(response) = result {
                self.dataDidLoad(response: response) { [weak self] in self?.present() }
            }
        }
    }
    
    func getTVShows() {
        task = homeUseCase.executeTVShows { _ in }
    }
    
    func getMovies() {
        task = homeUseCase.executeMovies { _ in }
    }
}
