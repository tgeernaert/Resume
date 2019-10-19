//
//  ResumeTests.swift
//  ResumeTests
//
//  Created by Terrence Geernaert on 2019-10-17.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import XCTest
@testable import Resume

struct MockDataFetcher: JSONDataFetcher {
    var dataURL: URL = URL(string: "http://www.atimi.com")!

    let data = Data("""
        {"space": {"value": 20}}
        """.utf8)

    func fetch<Resume>(type: Resume.Type, completion:  @escaping (Result<Resume, Error>) -> Void) where Resume: Decodable {        completion(Result {try JSONDecoder().decode(Resume.self, from: data)})
    }
}


class ThemedContentViewModelTests: XCTestCase {

    var mockDataFetcher: MockDataFetcher!
    var testNotificationCenter: NotificationCenter!

    override func setUp() {
        mockDataFetcher = MockDataFetcher()
        testNotificationCenter = NotificationCenter()
    }

    func testThemeChangesWhenThemeSet() {
        let themeChange = expectation(description: "Theme Change")
        let change: (Theme) -> Void = { _ in
            themeChange.fulfill()
        }
        let viewModel = DescribedViewModel(bindings: ThemedContentViewBindings(themeDidChange: change,
                                                                               contentViewDidChange: {_ in}),
                                           dataFetcher: mockDataFetcher,
                                           notificationCenter: testNotificationCenter)

        viewModel.theme = AlternativeTheme()

        waitForExpectations(timeout: 0.1)
    }

    func testInitialContentIsOnContstruction() {
        let contentChange = expectation(description: "Content Change")
        let change: (UIView) -> Void = { _ in
            contentChange.fulfill()
        }

        _ = DescribedViewModel(bindings: ThemedContentViewBindings(themeDidChange: {_ in},
                                                                               contentViewDidChange: change),
                                           dataFetcher: mockDataFetcher,
                                           notificationCenter: testNotificationCenter)

        waitForExpectations(timeout: 0.1)
    }

    func testContentChangesAgainWhenThemeSet() {
        let contentChange = expectation(description: "Content Change")
        contentChange.expectedFulfillmentCount = 2
        let change: (UIView) -> Void = { _ in
            contentChange.fulfill()
        }

        let viewModel = DescribedViewModel(bindings: ThemedContentViewBindings(themeDidChange: {_ in},
                                                                               contentViewDidChange: change),
                                           dataFetcher: mockDataFetcher,
                                           notificationCenter: testNotificationCenter)

        viewModel.theme = AlternativeTheme()

        waitForExpectations(timeout: 0.1)
    }

    func testContentChangesWithDyanamicTypeNotifications() {
        let dynamicTypeChange = expectation(forNotification: UIContentSizeCategory.didChangeNotification, object: nil)

        let change: (UIView) -> Void = { _ in
            dynamicTypeChange.fulfill()
        }

        _ = DescribedViewModel(bindings: ThemedContentViewBindings(themeDidChange: {_ in},
                                                                   contentViewDidChange: change),
                               dataFetcher: mockDataFetcher,
                               notificationCenter: testNotificationCenter)

        testNotificationCenter.post(name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        waitForExpectations(timeout: 0.1)
    }

}
