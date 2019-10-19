//
//  ViewDescriptor.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-17.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation
import UIKit

protocol ViewDescriptor: Decodable {
    func view(_ theme: Theme) -> UIView
    var viewType: ViewType { get }
}

protocol TextProviding {
    var text: String { get }
    var alignment: NSTextAlignment? { get }
}

protocol AttributedTextProviding {
    var attributedText: NSAttributedString { get }
}

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

struct Title: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .title(self)
    }

}

struct Heading: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .heading(self)
    }
}

struct Subheading: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .subheading(self)
    }
}

struct Body: ViewDescriptor, TextProviding {
    let text: String
    let alignment: NSTextAlignment?

    var viewType: ViewType {
        return .body(self)
    }
}

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

