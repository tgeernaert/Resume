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
    var background: UIColor { get }
}


struct DefaultTheme: Theme {

    func font(view: ViewType) -> UIFont? {
        switch view {
        case .body:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .bullet:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .heading:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .subheading:
            return UIFont.preferredFont(forTextStyle: .body)
        case .title:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
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
            return .darkGray
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

    var background: UIColor = .white

}

struct AlternativeTheme: Theme {

    func font(view: ViewType) -> UIFont? {
        switch view {
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        case .bullet:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .heading:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .subheading:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)
        default:
            return nil
        }
    }

    func forground(view: ViewType) -> UIColor {
        switch view {
        case .body:
            return .lightGray
        case .bullet:
            return .lightGray
        case .heading:
            return .lightGray
        case .space:
            return .clear
        case .stack:
            return .clear
        case .subheading:
            return .gray
        case .title:
            return .lightGray
        }
    }

    func background(view: ViewType) -> UIColor {
        switch view {
        case .body:
            return .darkGray
        case .bullet:
            return .darkGray
        case .heading:
            return .darkGray
        case .space:
            return .clear
        case .stack:
            return .clear
        case .subheading:
            return .darkGray
        case .title:
            return .darkGray
        }
    }

    var background: UIColor = .darkGray
}
