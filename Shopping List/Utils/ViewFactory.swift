//
//  ViewFactory.swift
//
//  Created by Dmitry Vorozhbicki on 01/11/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import Foundation

struct ViewFactory {
    static func displayListDetails(list: List) -> ListDetailsViewController {
        let vc = ListDetailsViewController.`init`(list: list)
        return vc
    }
}
