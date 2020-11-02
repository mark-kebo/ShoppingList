//
//  CurrentListViewModel.swift
//
//  Created by Dmitry Vorozhbicki on 01/11/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit

class CurrentListViewModel {
    private(set) var lists: [List] = []
    let storageService: StorageServiceProtocol
    private var delegate: ListViewModelDelegate?
    
    init(delegate: ListViewModelDelegate?) {
        self.delegate = delegate
        storageService = StorageService()
    }
}

extension CurrentListViewModel {
    func updateLists() {
        if let lists = storageService.currentLists(completion: { [weak self] (error) in
            if let error = error {
                self?.delegate?.showAlert(with: error)
            }
        }) {
            self.lists = lists
            self.delegate?.didUpdate()
        }
    }
    
    func archive(item: List) {
        item.archivedDate = Date()
        storageService.update { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.showAlert(with: error)
            }
            if let index = self.lists.firstIndex(of: item) {
                self.lists.remove(at: index)
                self.delegate?.didDeleteElement(at: IndexPath(row: index, section: 0))
            }
        }
    }
    
    func createNewList(with name: String) {
        let object = List(context: storageService.context)
        object.name = name
        object.createdDate = Date()
        storageService.save(object: object, completion: { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.showAlert(with: error)
            } else {
                self.lists.append(object)
                self.delegate?.didAppendNewElement(at: IndexPath(row: self.lists.count - 1, section: 0))
            }
        })
    }
}
