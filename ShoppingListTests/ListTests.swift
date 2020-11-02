//
//  ListTests.swift
//
//  Created by Dmitry Vorozhbicki on 01/11/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit
import XCTest
@testable import Shopping_List

class ListTests: XCTestCase {
    var currentListViewModel: CurrentListViewModel?
    var archiveListViewModel: ArchiveListViewModel?
    
    override func setUp() {
        super.setUp()
        currentListViewModel = CurrentListViewModel(delegate: nil)
        archiveListViewModel = ArchiveListViewModel(delegate: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
}
    

    // MARK: Tests Init
class InitTests: ListTests {
    
    func testInitCurrentListViewModel() {
        let instance = CurrentListViewModel(delegate: nil)
        XCTAssertNotNil(instance)
    }
    
    func testInitArchiveListViewModel() {
        let instance = ArchiveListViewModel(delegate: nil)
        XCTAssertNotNil(instance)
    }
    
    func testCurrentListCoreDataInit() {
        let instance = CurrentListViewModel(delegate: nil).storageService
        let coreDataStack = instance.persistentContainer
        XCTAssertNotNil(coreDataStack)
    }
    
    func testArchiveListCoreDataInit() {
        let instance = ArchiveListViewModel(delegate: nil).storageService
        let coreDataStack = instance.persistentContainer
        XCTAssertNotNil(coreDataStack)
    }
}


// MARK: Tests CurrentList
class CurrentListTests: ListTests {
    
    func testCreateList() {
        let name = "Test List"
        currentListViewModel?.createNewList(with: name)
        let lists = currentListViewModel?.lists
        XCTAssertNotNil(lists)
        let filteredLists = lists?.filter({ (list) -> Bool in
            list.name == name
        })
        XCTAssertFalse(filteredLists?.isEmpty ?? true)
    }
    
    func testFetchAllCurrentLists() {
        currentListViewModel?.updateLists()
        let results = currentListViewModel?.lists
        XCTAssertEqual(results?.count, 1)
    }
}

//MARK: Products
class ProductsTests: ListTests {
    func testCreateProduct() {
        currentListViewModel?.updateLists()
        let items = currentListViewModel?.lists
        XCTAssertNotNil(items)
        let list = items?.first
        var viewModel: ListDetailsViewModel? = nil
        if let list = list {
            viewModel = ListDetailsViewModel(list: list, delegate: nil)
        }
        XCTAssertNotNil(viewModel)
        
        let name = "Test Product"
        viewModel?.addProduct(with: name)
        let products = viewModel?.products
        XCTAssertNotNil(products)
        let filteredProducts = products?.filter({ (product) -> Bool in
            product.name == name
        })
        XCTAssertNotNil(filteredProducts)
        XCTAssertFalse(filteredProducts?.isEmpty ?? true)
    }
    
    func testDeleteProduct() {
        currentListViewModel?.updateLists()
        let items = currentListViewModel?.lists
        XCTAssertNotNil(items)
        let list = items?.first
        XCTAssertNotNil(list)
        
        var viewModel: ListDetailsViewModel? = nil
        if let list = list {
            viewModel = ListDetailsViewModel(list: list, delegate: nil)
        }
        XCTAssertNotNil(viewModel)
        
        let products = viewModel?.products
        let numberOfItems = products?.count ?? 0
        viewModel?.deleteItem(indexPath: IndexPath(item: 0, section: 0))
        XCTAssertEqual(viewModel?.products.count, numberOfItems-1)
    }
}
    
    // MARK: Tests ArchiveList
class ArchiveListTests: ListTests {

    func testArchiveList() {
        currentListViewModel?.updateLists()
        let items = currentListViewModel?.lists
        XCTAssertNotNil(items)
        let list = items?.first
        let numberOfItems = items?.count ?? 0
        XCTAssertNotNil(list)
        if let list = list {
            currentListViewModel?.archive(item: list)
        }
        XCTAssertNotNil(list?.archivedDate)
        XCTAssertEqual(currentListViewModel?.lists.count, numberOfItems-1)
        
        archiveListViewModel?.updateLists()
        let results = archiveListViewModel?.lists
        XCTAssertEqual(results?.count, 1)
    }
    
    func testDeleteArchivedList() {
        archiveListViewModel?.updateLists()
        let items = archiveListViewModel?.lists
        let numberOfItems = items?.count ?? 0
        archiveListViewModel?.deleteItem(indexPath: IndexPath(item: 0, section: 0))
        XCTAssertEqual(archiveListViewModel?.lists.count, numberOfItems-1)
    }
}
