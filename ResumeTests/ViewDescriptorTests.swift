//
//  ViewDescriptorTests.swift
//  ResumeTests
//
//  Created by Terrence Geernaert on 2019-10-18.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import XCTest
@testable import Resume

class ViewDescriptorTests: XCTestCase {

    func testViewDescriptorDecodeVStack() {
        let testJson = Data("""
        {
            "stack": {
                "axis": "verticle",
                "subviews": [ ]
            }
        }
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeHStack() {
        let testJson = Data("""
        {
            "stack": {
                "axis": "horizontal",
                "subviews": [ ]
            }
        }
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeFixedSpace() {
        let testJson = Data("""
        {"space": {"value": 20}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeFlexSpace() {
        let testJson = Data("""
        {"space": {"value": "flex"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeTitle() {
        let testJson = Data("""
        {"title": { "text": "Title" }}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeHeading() {
        let testJson = Data("""
        {"heading": {"text": "Heading"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeSubheading() {
        let testJson = Data("""
        {"subheading": {"text": "Subheading"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeBodyFrom() {
        let testJson = Data("""
        {"body": {"text": "Body"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeBullet() {
        let testJson = Data("""
        {"bullet": {"text": "Body"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeTextAlignmentLeft() {
        let testJson = Data("""
        {"body": {"text": "Body", "alignment": "left"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeTextAlignmentRight() {
        let testJson = Data("""
        {"body": {"text": "Body", "alignment": "right"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeTextAlignmentCenter() {
        let testJson = Data("""
        {"body": {"text": "Body", "alignment": "center"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeTextAlignmentJustified() {
        let testJson = Data("""
        {"body": {"text": "Body", "alignment": "justified"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

    func testViewDescriptorDecodeTextAlignmentNatural() {
        let testJson = Data("""
        {"body": {"text": "Body", "alignment": "natural"}}
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }

}
