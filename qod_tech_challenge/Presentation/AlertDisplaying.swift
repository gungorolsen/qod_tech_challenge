//
//  AlertDisplaying.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import UIKit

protocol AlertDisplaying {
    func showErrorAlert(title: String, message: String)
}

extension AlertDisplaying where Self: UIViewController {
 
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
