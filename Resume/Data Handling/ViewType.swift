//
//  ViewType.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-18.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation

/// A type that is used in decoding JSON into the various kinds of VIewDescriptors and diferentiating the types when bulding the views
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

