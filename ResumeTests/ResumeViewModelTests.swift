//
//  ResumeTests.swift
//  ResumeTests
//
//  Created by Terrence Geernaert on 2019-10-17.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import XCTest
@testable import Resume

class MockViewController: UIViewController {

}

class ResumeViewModelTests: XCTestCase {

    var mockViewController: MockViewController?

    override func setUp() {
        mockViewController = MockViewController()
    }

    func testExampleThemeChangesWhenThemeSet() {
        let themeChange = expectation(description: "Theme Change")
        let themeDidChange: (Theme) -> Void = { _ in
            themeChange.fulfill()
        }
        let viewModel = DescribedViewModel(bindings: ResumeViewBindings(themeDidChange: themeDidChange,
                                                                        contentViewDidChange: {_ in}))
        viewModel.theme = AlternativeTheme()

        waitForExpectations(timeout: 0.1)
    }

    func testExampleContentChangesWhenThemeSet() {
        let contentChange = expectation(description: "Content Change")
        contentChange.expectedFulfillmentCount = 2
        let contentViewDidChange: (UIView) -> Void = { _ in
            contentChange.fulfill()
        }
        let viewModel = DescribedViewModel(bindings: ResumeViewBindings(themeDidChange: {_ in},
                                                                        contentViewDidChange: contentViewDidChange))
        viewModel.theme = AlternativeTheme()

        waitForExpectations(timeout: 0.1)
    }
}
