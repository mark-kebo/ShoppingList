//
//  ListDetailsViewModel.swift
//
//  Created by Dmitry Vorozhbicki on 01/11/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import Foundation

class ListDetailsViewModel {
    private(set) var list: List
    var products: [Product] {
        return list.products?.allObjects as? [Product] ?? []
    }
    let storageService: StorageServiceProtocol
    private var delegate: ListViewModelDelegate?
    
    init(list: List, delegate: ListViewModelDelegate?) {
        self.list = list
        self.delegate = delegate
        storageService = StorageService()
    }
}

extension ListDetailsViewModel {
    func addProduct(with text: String) {
        let product = Product(context: storageService.context)
        product.name = text
        product.list = list
        list.addToProducts(product)
        storageService.update { [weak self] (error) in
            if let error = error {
                self?.delegate?.showAlert(with: error)
            }
        }
        if let index = products.firstIndex(of: product) {
            self.delegate?.didAppendNewElement(at: IndexPath(row: index, section: 0))
        } else {
            self.delegate?.didUpdate()
        }
    }
    
    func deleteItem(indexPath: IndexPath) {
        list.removeFromProducts(products[indexPath.row])
        storageService.update { [weak self] (error) in
            if let error = error {
                self?.delegate?.showAlert(with: error)
            }
        }
        self.delegate?.didDeleteElement(at: indexPath)
    }
}
