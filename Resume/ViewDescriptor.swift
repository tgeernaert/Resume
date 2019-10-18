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

// TODO: move this into a separate file, so that we can remove the UIKit import
extension ViewDescriptor {
    func view(_ theme: Theme = DefaultTheme()) -> UIView {
        switch self.viewType {
        case .body, .bullet, .heading, .subheading, .title:
            let label = UILabel(frame: .zero)
            label.font = theme.font(view: viewType)
            label.textColor = theme.forground(view: viewType)
            label.backgroundColor = theme.background(view: viewType)
            label.textAlignment = .left
            return label
        case .stack(let stack):
            let stackView = UIStackView(arrangedSubviews: stack.subviews.map { $0.descriptor.view(theme) })
            stackView.axis = stack.axis
            return stackView
        case .space(let space):
            let view = UIView(frame: .zero)
            view.backgroundColor = theme.background(view: viewType)

            switch space.value {
            case .fixed(let value):
                view.translatesAutoresizingMaskIntoConstraints = false
                view.widthAnchor.constraint(equalToConstant: CGFloat(value)).isActive = true
                view.heightAnchor.constraint(equalToConstant: CGFloat(value)).isActive = true
            case .flexible:
                view.setContentHuggingPriority(.init(1), for: .horizontal)
                view.setContentHuggingPriority(.init(1), for: .vertical)
            }
            return view
        }
    }
}

enum ViewType: Decodable {
    case stack(Stack)
    case title(Title)
    case heading(Heading)
    case subheading(Subheading)
    case body(Body)
    case bullet(Bullet)
    case space(Space)

    var descriptor: ViewDescriptor {
        switch self {
        case .stack(let descriptor):
            return descriptor
        case .title(let descriptor):
            return descriptor
        case .heading(let descriptor):
            return descriptor
        case .subheading(let descriptor):
            return descriptor
        case .body(let descriptor):
            return descriptor
        case .bullet(let descriptor):
            return descriptor
        case .space(let descriptor):
            return descriptor
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch container.allKeys[0] {
        case .stack:
            self = ViewType.stack(try container.decode(Stack.self, forKey: CodingKeys.stack))
        case .title:
            self = ViewType.title(try container.decode(Title.self, forKey: CodingKeys.title))
        case .heading:
            self = ViewType.heading(try container.decode(Heading.self, forKey: CodingKeys.heading))
        case .subheading:
            self = ViewType.subheading(try container.decode(Subheading.self, forKey: CodingKeys.subheading))
        case .body:
            self = ViewType.body(try container.decode(Body.self, forKey: CodingKeys.body))
        case .bullet:
            self = ViewType.bullet(try container.decode(Bullet.self, forKey: CodingKeys.bullet))
        case .space:
            self = ViewType.space(try container.decode(Space.self, forKey: CodingKeys.space))
        }
    }

    private enum CodingKeys: String, CodingKey {
        case stack
        case title
        case heading
        case subheading
        case body
        case bullet
        case space
    }
}


struct Stack: ViewDescriptor {
    let subviews: [ViewType]
    let axis: NSLayoutConstraint.Axis

    enum StackKeys: String, CodingKey {
        case subviews = "subviews"
        case axis = "axis"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StackKeys.self)
        self.subviews = try container.decode(Array.self, forKey: .subviews)
        switch try container.decode(String.self, forKey: .axis) {
        case "horizontal":
            axis = .horizontal
        case "verticle":
            axis = .vertical
        default:
            fatalError()
        }
    }

    var viewType: ViewType {
        return .stack(self)
    }
}

struct Title: ViewDescriptor {
    let text: String

    var viewType: ViewType {
        return .title(self)
    }

}

struct Heading: ViewDescriptor {
    let text: String

    var viewType: ViewType {
        return .heading(self)
    }
}

struct Subheading: ViewDescriptor {
    let text: String

    var viewType: ViewType {
        return .subheading(self)
    }
}

struct Body: ViewDescriptor {
    let text: String

    var viewType: ViewType {
        return .body(self)
    }
}

struct Bullet: ViewDescriptor {
    let text: String

    var viewType: ViewType {
        return .bullet(self)
    }
}

struct Space: ViewDescriptor {
    let value: SpaceValue

    enum SpaceValue {
        case flexible
        case fixed(Int)
    }

    enum SpaceKeys: String, CodingKey {
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SpaceKeys.self)

        if let interger = try? container.decode(Int.self, forKey: .value) {
            value = .fixed(interger)
        } else {
            if try container.decode(String.self, forKey: .value) == "flex" {
                value = .flexible
            } else {
                fatalError()
            }
        }
    }

    var viewType: ViewType {
        return .space(self)
    }
}

