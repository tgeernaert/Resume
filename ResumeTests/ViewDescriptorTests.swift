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

    func testViewDescriptorDecodeFromDataToView() {
        let testJson = Data("""
        {
            "stack": {
                "axis": "verticle",
                "subviews": [
                    {"title": { "text": "Terrence Geernaert" }},
                    {"stack": {
                        "axis": "horizontal",
                        "subviews": [
                            {"body": {"text": "778.229.0717"}},
                            {"body": {"text": "tgeernaert@mac.com"}},
                            {"body": {"text": "13045 239B Street, Maple Ridge, BC, Canada"}}
                        ]
                    }}
                ]
            }
        }
        """.utf8)

        let viewDescriptor = (try? JSONDecoder().decode(ViewType.self, from: testJson))?.descriptor
        XCTAssertNotNil(viewDescriptor?.view())
    }
}
