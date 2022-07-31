//
//  EndEditing.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import UIKit

protocol EndEditing {
    func endEditing()
}

extension EndEditing where Self: UIViewController {
 
    func endEditing() {
        view.endEditing(true)
    }
}
