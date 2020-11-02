//
//  BaseViewController.swift
//
//  Created by Dmitry Vorozhbicki on 28/10/2019.
//  Copyright © 2019 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addRightNavigationButton(selector: Selector, title: String) {
        let rightBarButtonItem : UIBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: selector)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

//MARK: - Show Errors
extension BaseViewController {
    func  showFailWithMessage(_ message:String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func showAlertWithTextField(title: String, message: String, completion:((String) -> ())? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
            guard let textField = alert.textFields?.first,
                let text = textField.text else {
                return
            }
            completion?(text)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
