//  SearchTests.swift
//  Created by Łukasz Rutkowski on 12/02/2023.

import XCTest
@testable import TootSDK

final class SearchTests: XCTestCase {

    func testSearchParamsToQueryItems() throws {
        let allParams = SearchParams(
            query: "value",
            type: .posts,
            resolve: true,
            following: false,
            accountId: "id",
            excludeUnreviewed: true
        )
        XCTAssertEqual(allParams.queryItems, [
            URLQueryItem(name: "q", value: "value"),
            URLQueryItem(name: "type", value: "statuses"),
            URLQueryItem(name: "resolve", value: "true"),
            URLQueryItem(name: "following", value: "false"),
            URLQueryItem(name: "account_id", value: "id"),
            URLQueryItem(name: "exclude_unreviewed", value: "true")
        ])

        let requiredParams = SearchParams(query: "value")
        XCTAssertEqual(requiredParams.queryItems, [URLQueryItem(name: "q", value: "value")])
    }
}
