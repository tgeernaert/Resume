//
//  Theme.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-18.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation
import UIKit

protocol Theme {
    func font(view: ViewType) -> UIFont?
    func forground(view: ViewType) -> UIColor
    func background(view: ViewType) -> UIColor
}

struct DefaultTheme: Theme {

    func font(view: ViewType) -> UIFont? {
        switch view {
        case .body:
            return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        case .bullet:
            return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        case .heading:
            return UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        case .subheading:
            return UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        case .title:
            return UIFont.systemFont(ofSize: UIFont.systemFontSize * 2)
        default:
            return nil
        }
    }

    func forground(view: ViewType) -> UIColor {
        switch view {
        case .body:
            return .black
        case .bullet:
            return .black
        case .heading:
            return .black
        case .space:
            return .clear
        case .stack:
            return .clear
        case .subheading:
            return .black
        case .title:
            return .black
        }
    }

    func background(view: ViewType) -> UIColor {
        switch view {
        case .body:
            return .white
        case .bullet:
            return .white
        case .heading:
            return .white
        case .space:
            return .clear
        case .stack:
            return .clear
        case .subheading:
            return .white
        case .title:
            return .white
        }
    }
}
