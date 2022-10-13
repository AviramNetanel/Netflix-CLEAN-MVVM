//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - HomeViewModelActions struct

struct HomeViewModelActions {
    let presentMediaDetails: (Section, Media) -> Void
}

// MARK: - HomeViewModelEndpoints protocol

private protocol HomeViewModelEndpoints {
    func getSections()
}

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func viewDidLoad()
    func dataDidLoad(response: SectionsResponse, completion: @escaping () -> Void)
    func filter(sections: [Section])
    func filter(sections: [Section], at index: Int, withMinimumRating value: Float?)
    func sort(section: Section)
    func prefix(section: Section, by length: Int)
    func section(at index: TableViewDataSource.Index) -> Section
    func title(forHeaderAt index: Int) -> String
    func randomObject(at section: Section) -> Media
    func presentedDisplayMediaDidChange()
    
    var navigationViewDidAppear: (() -> Void)? { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var state: Observable<TableViewDataSource.State> { get }
    var sections: Observable<[Section]> { get }
    var presentedDisplayMedia: Observable<Media?> { get }
    var isEmpty: Bool { get }
}

// MARK: - ViewModel protocol

private typealias ViewModel = ViewModelInput & ViewModelOutput & HomeViewModelEndpoints

// MARK: - HomeViewModel class

final class HomeViewModel: ViewModel {
    
    private(set) var homeUseCase: HomeUseCase
    private(set) var actions: HomeViewModelActions
    
    private var task: Cancellable? { willSet { task?.cancel() } }
    
    fileprivate(set) var state: Observable<TableViewDataSource.State> = Observable(.tvShows)
    fileprivate(set) var sections: Observable<[Section]> = Observable([])
    private(set) var presentedDisplayMedia: Observable<Media?> = Observable(nil)
    fileprivate var isEmpty: Bool { return sections.value.isEmpty }
    
    var navigationViewDidAppear: (() -> Void)?
    
    init(homeUseCase: HomeUseCase,
         actions: HomeViewModelActions) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
    
    deinit {
        task = nil
        navigationViewDidAppear = nil
    }
    
    private func present() {
        navigationViewDidAppear?()
        // Main entry-point for tableview.
        state.value = .tvShows
    }
}

// MARK: - ViewModelInput implementation

extension HomeViewModel {
    
    func viewDidLoad() {
        getSections()
    }
    
    func dataDidLoad(response: SectionsResponse, completion: @escaping () -> Void) {
        sections.value = response.data
        filter(sections: sections.value)
        
        completion()
    }
    
    func filter(sections: [Section]) {
        for index in TableViewDataSource.Index.allCases {
            switch index {
            case .ratable:
                sections[index.rawValue].tvshows = sections.first!.tvshows
                sections[index.rawValue].movies = sections.first!.movies
                
                sort(section: sections[index.rawValue])
                prefix(section: sections[index.rawValue], by: 10)
            case .resumable:
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
    
    func sort(section: Section) {
        section.tvshows = section.tvshows?.sorted { $0.rating > $1.rating }
        section.movies = section.movies?.sorted { $0.rating > $1.rating }
    }
    
    func prefix(section: Section, by length: Int) {
        let tvShowsSlice = section.tvshows!.prefix(10)
        let moviesSlice = section.movies!.prefix(10)
        section.tvshows = Array(tvShowsSlice)
        section.movies = Array(moviesSlice)
    }
    
    func section(at index: TableViewDataSource.Index) -> Section {
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

fileprivate extension HomeViewModel {
    
    func getSections() {
        task = homeUseCase.execute(for: SectionsResponse.self) { [weak self] result in
            guard let self = self else { return }
            if case let .success(response) = result {
                self.dataDidLoad(response: response) { [weak self] in self?.present() }
            }
        }
    }
}
