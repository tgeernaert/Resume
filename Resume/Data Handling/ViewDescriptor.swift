//
//  ViewDescriptor.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-17.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation
import UIKit

/// Allow description of a view heirarchy in a JSON file
protocol ViewDescriptor: Decodable {
    /// The view builder for the view descriptor
    /// - parameter theme: Defines styling to be applied when building the views
    func view(_ theme: Theme) -> UIView

    ///  Access to the ViewType for the view descriptor
    var viewType: ViewType { get }
}

///  ViewDescriptors that can provide text to be displayed in the view that the describe
protocol TextProviding {
    /// The text to be displayed in the view
    var text: String { get }
    /// The alignment to be used for the text
    var alignment: NSTextAlignment? { get }
}

///  ViewDescriptors that can provide attributed text to be displayed in the view that the describe
protocol AttributedTextProviding {
    /// The text with attribues to be displayed in the view
    var attributedText: NSAttributedString { get }
}

/// A collection of subviews, can be either verticle or horizontal
struct Stack: ViewDescriptor {
    let subviews: [ViewType]
    let axis: NSLayoutConstraint.Axis

    var viewType: ViewType {
        return .stack(self)
    }
}

extension NSLayoutConstraint.Axis: Decodable {
    enum CodingKeys: String, CodingKey {
        case axis = "axis"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        switch try? container.decode(String.self) {
        case "horizontal":
            self = NSLayoutConstraint.Axis.horizontal
        case "verticle":
            self = NSLayoutConstraint.Axis.vertical
        default:
            fatalError()
        }
    }
}

/// A view that contains text with Title styling from the Theme
struct Title: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .title(self)
    }

}

/// A view that contains text with Heading styling from the Theme
struct Heading: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .heading(self)
    }
}

/// A view that contains text with Subheading styling from the Theme
struct Subheading: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .subheading(self)
    }
}

/// A view that contains text with Body styling from the Theme
struct Body: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .body(self)
    }
}

/// A view that contains bulletted text with Bullet styling from the Theme
struct Bullet: ViewDescriptor, AttributedTextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var attributedText: NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment ?? .natural
        style.headIndent = 10

        return NSAttributedString(string: "• \(text)", attributes: [.paragraphStyle: style])
    }

    var viewType: ViewType {
        return .bullet(self)
    }
}

extension NSTextAlignment: Decodable {

    enum CodingKeys: String, CodingKey {
        case alignment
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        switch try? container.decode(String.self) {
        case "left":
            self = NSTextAlignment.left
        case "center":
            self = NSTextAlignment.center
        case "right":
            self = NSTextAlignment.right
        case "justified":
            self = NSTextAlignment.justified
        case "natural", .none:
            self = NSTextAlignment.natural
        default:
            fatalError()
        }
    }
}

/// Defines a view that provide spaces in the view heirarchy
struct Space: ViewDescriptor {
    let value: SpaceValue

    enum SpaceValue: Decodable {
        case flexible
        case fixed(Double)

        enum CodingKeys: String, CodingKey {
            case value
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let value = try? container.decode(Double.self) {
                self = .fixed(value)
            } else {
                if try container.decode(String.self) == "flex" {
                    self = .flexible
                } else {
                    fatalError()
                }
            }
        }
    }

    var viewType: ViewType {
        return .space(self)
    }
}

