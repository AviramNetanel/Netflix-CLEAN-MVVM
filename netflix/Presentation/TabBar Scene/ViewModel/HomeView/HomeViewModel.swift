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
    var media: Observable<[Media]> { get }
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
    private var task2: Cancellable? { willSet { task?.cancel() } }
    
    fileprivate(set) var state: Observable<TableViewDataSource.State> = Observable(.tvShows)
    fileprivate(set) var sections: Observable<[Section]> = Observable([])
    fileprivate(set) var media: Observable<[Media]> = Observable([])
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
        
        completion()
    }
    
    func dataDidLoad(response: MediasResponse, completion: @escaping () -> Void) {
        media.value = response.data
        filter(sections: sections.value)
        
        completion()
    }
    
    func filter(sections: [Section]) {
        for index in TableViewDataSource.Index.allCases {
            switch index {
            case .ratable:
                media.value = media.value.sorted { $0.rating > $1.rating }
                media.value = media.value.filter { $0.rating > 7.5 }
                let slice = media.value.prefix(10)
                sections[index.rawValue].media = Array(slice)
            case .resumable:
                media.value = media.value.shuffled()
                sections[index.rawValue].media = media.value
            case .action, .sciFi,
                    .crime, .thriller,
                    .adventure, .comedy,
                    .drama, .horror,
                    .anime, .familyNchildren,
                    .documentary:
                media.value = media.value.shuffled()
                filter(sections: sections, at: index.rawValue)
            case .blockbuster:
                media.value = media.value.shuffled()
                filter(sections: sections, at: index.rawValue, withMinimumRating: 7.5)
            default: break
            }
        }
    }
    
    func filter(sections: [Section],
                at index: Int,
                withMinimumRating value: Float? = nil) {
        guard let value = value else {
            sections[index].media = media.value.filter {
                $0.genres.contains(sections[index].title)
            }
            sections[index].media = media.value.filter {
                $0.genres.contains(sections[index].title)
            }
            return
        }
        sections[index].media = media.value.filter { $0.rating > value }
    }
    
    func sort(section: Section) {
        section.media = media.value.sorted { $0.rating > $1.rating }
    }
    
    func prefix(section: Section, by length: Int) {
        let slice = media.value.prefix(10)
        section.media = Array(slice)
    }
    
    func section(at index: TableViewDataSource.Index) -> Section {
        return sections.value[index.rawValue]
    }
    
    func title(forHeaderAt index: Int) -> String {
        return .init(describing: sections.value[index].title)
    }
    
    func randomObject(at section: Section) -> Media {
        return state.value == .tvShows
            ? media.value.randomElement()!
            : media.value.randomElement()!
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
                self.dataDidLoad(response: response) {
                    self.getMedia()
                }
            }
        }
    }
    
    func getMedia() {
        task2 = homeUseCase.execute(for: MediasResponse.self) { [weak self] result in
            guard let self = self else { return }
            if case let .success(response) = result {
                self.dataDidLoad(response: response) { [weak self] in
                    self?.present()
                }
            }
        }
        
        Task {
            let string = "https://netflix-swift-api.herokuapp.com/api/v1/media/the-witcher"
            let urls: [URL] = Array(0...1).map { _ in
                URL(string: string)
            }.compactMap { $0 }
            
            for try await data in DataSequence(urls: urls) {
                let media = try! JSONDecoder().decode(MediaResponseDTO.self, from: data)
                print(media.data.toDomain())
            }
        }
    }
}


struct DataSequence: AsyncSequence {
    
    typealias Element = Data
    
    let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    func makeAsyncIterator() -> DataIterator {
        return DataIterator(urls: urls)
    }
}

struct DataIterator: AsyncIteratorProtocol {
    
    typealias Element = Data
    
    private var index = 0
    private let urlSession = URLSession.shared
    let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    mutating func next() async throws -> Data? {
        guard index < urls.count else { return nil }
        
        let url = urls[index]
        index += 1
        
        if #available(iOS 15.0, *) {
            let (data, _) = try await urlSession.data(from: url)
            return data
        }
        print("na")
        return nil
    }
}
