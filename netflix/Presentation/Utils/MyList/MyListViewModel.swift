//
//  MyListViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/12/2022.
//

import Foundation

struct MyListActions {
    let listDidReload: () -> Void
}

final class MyListViewModel {
    private var task: Cancellable? { willSet { task?.cancel() } }
    private(set) var list: Observable<Set<Media>> = Observable([])
    private let user: UserDTO
    private let homeUseCase: HomeUseCase
    private(set) var section: Section
    private(set) var actions: MyListActions
    
    init(with viewModel: HomeViewModel) {
        self.user = Application.current.authService.user ?? .init()
        self.homeUseCase = viewModel.useCase
        self.section = viewModel.section(at: .myList)
        self.actions = MyListActions(
            listDidReload: {
                guard
                    viewModel.coordinator!.viewController!.tableView.numberOfSections > 0,
                    let myListIndex = HomeTableViewDataSource.Index(rawValue: 6),
                    let section = viewModel.coordinator!.viewController?.viewModel?.section(at: .myList)
                else { return }
                viewModel.coordinator!.viewController?.viewModel?.filter(section: section)
                let index = IndexSet(integer: myListIndex.rawValue)
                viewModel.coordinator!.viewController?.tableView.reloadSections(index, with: .automatic)
            })
    }
    
    deinit {
        task = nil
    }
}

extension MyListViewModel {
    func fetchList() {
        let requestDTO = ListRequestDTO.GET(user: user)
        task = homeUseCase.execute(
            for: ListResponseDTO.GET.self,
            request: requestDTO,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(responseDTO) = result {
                    self.list.value = responseDTO.data.toDomain().media.toSet()
                    self.section.media = self.list.value.toArray()
                }
                if case let .failure(error) = result { print(error) }
            })
    }
    
    func createList() {
        guard let media = section.media as [Media]? else { return }
        let requestDTO = ListRequestDTO.POST(user: user._id!,
                                             media: media.toObjectIDs())
        task = homeUseCase.execute(
            for: ListResponseDTO.POST.self,
            request: requestDTO,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(responseDTO) = result {
                    self.list.value = responseDTO.data.toDomain().media.toSet()
                    self.section.media = self.list.value.toArray()
                }
                if case let .failure(error) = result { print(error) }
            })
    }
    
    fileprivate func updateList() {
        guard let media = section.media as [Media]? else { return }
        let requestDTO = ListRequestDTO.PATCH(user: user._id!,
                                              media: media.toObjectIDs())
        task = homeUseCase.execute(
            for: ListResponseDTO.PATCH.self,
            request: requestDTO,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(responseDTO) = result {
                    self.list.value = responseDTO.data.toDomain().media.toSet()
                    self.section.media = self.list.value.toArray()
                }
                if case let .failure(error) = result { print(error) }
            })
    }
    
    func shouldAddOrRemove(_ media: Media, uponSelection selected: Bool) {
        if selected {
            list.value.remove(media)
            section.media = list.value.toArray()
        } else {
            list.value.insert(media)
            section.media = list.value.toArray()
        }
        
        updateList()
        actions.listDidReload()
    }
    
    func contains(_ media: Media, in list: [Media]) -> Bool {
        return list.contains(media)
    }
}
