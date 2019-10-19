//
//  Theme.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-18.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation
import UIKit

/// Interface for defining the theme for a view heirarchy created from ViewDescriptors.
protocol Theme {
    /// The font provided to each ViewType
    func font(view: ViewType) -> UIFont?

    /// The forground (Font) color provided to each ViewType
    func forground(view: ViewType) -> UIColor

    /// The bacground (View) color provided to each ViewType
    func background(view: ViewType) -> UIColor

    /// The background color to be used by to the host container
    var background: UIColor { get }

    /// The forground color to be used by to the host container
    var forground: UIColor { get }

    /// The forground color for buttons and other action callouts
    var action: UIColor { get }
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
    var forground: UIColor = .darkGray
    var action: UIColor = .blue
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
    var forground: UIColor = .lightGray
    var action: UIColor = .yellow
}
