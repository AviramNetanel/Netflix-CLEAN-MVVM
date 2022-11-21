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

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func viewWillLoad()
    func viewDidLoad()
    func fetchSections()
    func fetchMedia()
    func filter(sections: [Section])
    func section(at index: TableViewDataSource.Index) -> Section
    func generateMedia(for state: TableViewDataSource.State) -> Media
    func presentedDisplayMediaDidChange()
    var navigationViewDidAppear: (() -> Void)? { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var authService: AuthService! { get }
    var homeUseCase: HomeUseCase! { get }
    var actions: HomeViewModelActions! { get }
    var tableViewState: Observable<TableViewDataSource.State> { get }
    var sections: [Section] { get }
    var media: [Media] { get }
    var presentedDisplayMedia: Observable<Media?> { get }
    var isEmpty: Bool { get }
    var myList: MyList! { get }
}

// MARK: - ViewModel protocol

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - HomeViewModel class

final class HomeViewModel: ViewModel {
    
    private var sectionsTask: Cancellable? { willSet { sectionsTask?.cancel() } }
    private var mediaTask: Cancellable? { willSet { mediaTask?.cancel() } }
    
    fileprivate(set) var authService: AuthService!
    fileprivate(set) var homeUseCase: HomeUseCase!
    fileprivate(set) var actions: HomeViewModelActions!
    fileprivate(set) var sections: [Section] = []
    fileprivate(set) var media: [Media] = []
    fileprivate(set) var tableViewState: Observable<TableViewDataSource.State> = Observable(.series)
    private(set) var presentedDisplayMedia: Observable<Media?> = Observable(nil)
    fileprivate var isEmpty: Bool { sections.isEmpty }
    
    var navigationViewDidAppear: (() -> Void)?
    
    var myList: MyList!
    var myListDidSetup: (() -> Void)?
    
    var displayMediaCache: [TableViewDataSource.State: Media] = [:]
    
    deinit {
        myListDidSetup = nil
        myList = nil
        navigationViewDidAppear = nil
        mediaTask = nil
        sectionsTask = nil
        authService = nil
        actions = nil
        homeUseCase = nil
    }
    
    static func create(authService: AuthService,
                       homeUseCase: HomeUseCase,
                       actions: HomeViewModelActions) -> HomeViewModel {
        let viewModel = HomeViewModel()
        viewModel.homeUseCase = homeUseCase
        viewModel.actions = actions
        viewModel.authService = authService
        return viewModel
    }
}

// MARK: - ViewModelInput implementation

extension HomeViewModel {
    
    func viewWillLoad() {
        // Invokes request for sections data.
        fetchSections()
    }
    
    fileprivate func viewDidLoad() {
        // Invokes navigation bar presentation.
        navigationViewDidAppear?()
        // Invokes tableview presentation.
        tableViewState.value = .all
        // Invokes user's list.
        myListDidSetup?()
    }
    
    fileprivate func fetchSections() {
        sectionsTask = homeUseCase.execute(
            for: SectionResponse.GET.self,
            request: Any.self,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(response) = result {
                    self.sections = response.data
                    self.fetchMedia()
                }
            })
    }
    
    fileprivate func fetchMedia() {
        mediaTask = homeUseCase.execute(
            for: MediaResponse.GET.Many.self,
            request: MediaRequestDTO.self,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(response) = result {
                    self.media = response.data
                    self.viewDidLoad()
                }
            })
    }
    
    func filter(section: Section) {
        guard !isEmpty else { return }
        
        if section.id == 6 {
            var media = myList.list.value
            switch tableViewState.value {
            case .all:
                break
            case .series:
                media = media.filter { $0.type == .series }
            case .films:
                media = media.filter { $0.type == .film }
            }
            sections[section.id].media = Array(media)
        }
    }
    
    func filter(sections: [Section]) {
        guard !isEmpty else { return }
        
        TableViewDataSource.Index.allCases.forEach { index in
            switch index {
            case .ratable:
                var media = media
                switch tableViewState.value {
                case .all:
                    media = media
                        .sorted { $0.rating > $1.rating }
                        .filter { $0.rating > 7.5 }
                        .slice(10)
                case .series:
                    media = media
                        .filter { $0.type == .series }
                        .sorted { $0.rating > $1.rating }
                        .filter { $0.rating > 7.5 }
                        .slice(10)
                case .films:
                    media = media
                        .filter { $0.type == .film }
                        .sorted { $0.rating > $1.rating }
                        .filter { $0.rating > 7.5 }
                        .slice(10)
                }
                sections[index.rawValue].media = media
            case .resumable:
                var media = media
                switch tableViewState.value {
                case .all:
                    media = media.shuffled()
                case .series:
                    media = media
                        .shuffled()
                        .filter { $0.type == .series }
                case .films:
                    media = media
                        .shuffled()
                        .filter { $0.type == .film }
                }
                sections[index.rawValue].media = media
            case .myList:
                var media = myList.list.value
                switch tableViewState.value {
                case .all:
                    break
                case .series:
                    media = media.filter { $0.type == .series }
                case .films:
                    media = media.filter { $0.type == .film }
                }
                sections[index.rawValue].media = Array(media)
            case .action, .sciFi,
                    .crime, .thriller,
                    .adventure, .comedy,
                    .drama, .horror,
                    .anime, .familyNchildren,
                    .documentary:
                switch tableViewState.value {
                case .all:
                    sections[index.rawValue].media = media
                        .shuffled()
                        .filter { $0.genres.contains(sections[index.rawValue].title) }
                case .series:
                    sections[index.rawValue].media = media
                        .shuffled()
                        .filter { $0.type == .series }
                        .filter { $0.genres.contains(sections[index.rawValue].title) }
                case .films:
                    sections[index.rawValue].media = media
                        .shuffled()
                        .filter { $0.type == .film }
                        .filter { $0.genres.contains(sections[index.rawValue].title) }
                }
            case .blockbuster:
                let value = Float(7.5)
                switch tableViewState.value {
                case .all:
                    sections[index.rawValue].media = media
                        .filter { $0.rating > value }
                case .series:
                    sections[index.rawValue].media = media
                        .filter { $0.type == .series }
                        .filter { $0.rating > value }
                case .films:
                    sections[index.rawValue].media = media
                        .filter { $0.type == .film }
                        .filter { $0.rating > value }
                }
            default: break
            }
        }
    }
    
    func section(at index: TableViewDataSource.Index) -> Section {
        sections[index.rawValue]
    }
    
    fileprivate func generateMedia(for state: TableViewDataSource.State) -> Media {
        guard displayMediaCache[state] == nil else { return displayMediaCache[state]! }
        switch state {
        case .all:
            displayMediaCache[state] = media.randomElement()
        case .series:
            displayMediaCache[state] = media
                .filter { $0.type == .series }
                .randomElement()!
        case .films:
            displayMediaCache[state] = media
                .filter { $0.type == .film }
                .randomElement()!
        }
        return displayMediaCache[state]!
    }
    
    func presentedDisplayMediaDidChange() {
        presentedDisplayMedia.value = generateMedia(for: tableViewState.value)
    }
}
