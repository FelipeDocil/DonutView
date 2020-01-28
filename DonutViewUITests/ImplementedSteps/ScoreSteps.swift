//
//  ScoreSteps.swift
//  DonutViewUITests
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import XCTest

extension ViewScoreOnDashboardFeatureTest {
    var app: XCUIElement {
        return XCUIApplication()
    }
}

enum ScoreNetworkingArguments: String {
    case has = "Has"
    case hasNot = "HasNot"

    var arguments: [String] {
        switch self {
        case .has: return [Arguments.Networking.success.rawValue]
        case .hasNot: return [Arguments.Networking.noNetwork.rawValue]
        }
    }
}

// MARK: - Launch App

extension ViewScoreOnDashboardFeatureTest {
    func launchScenarioUserCanSeeTheScore(with arguments: String, file _: StaticString = #file, line _: UInt = #line) {
        var args: [String] = [Arguments.Initial.dashboard.rawValue]

        let splittedArguments = arguments.components(separatedBy: "And")

        if let networking = splittedArguments.last, let networkingEnum = ScoreNetworkingArguments(rawValue: networking) {
            args.append(contentsOf: networkingEnum.arguments)
        }

        launchApp(arguments: args)
    }
}

// MARK: - Steps

extension ViewScoreOnDashboardFeatureTest {
    func stepUserIsOnTheDashboardScreen(file: StaticString = #file, line: UInt = #line) {
        XCTAssert(app.otherElements["dashboard_view"].exists, "User is not on dashboard screen", file: file, line: line)
    }
    
    func stepUserNetwork(hasOrNot: String, file: StaticString = #file, line: UInt = #line) {
        let progressView = app.otherElements["dashboard_view_progress_view"]
        XCTAssert(progressView.exists, "User cannot see the progress view", file: file, line: line)
        
        let scoreValueView = app.staticTexts["dashboard_view_score_value_label"]
        XCTAssert(scoreValueView.exists, "User cannot see the score value", file: file, line: line)
        
        let maximumView = app.staticTexts["dashboard_view_maximum_label"]
        XCTAssert(maximumView.exists, "User cannot see the score value", file: file, line: line)
    }
    
    func stepUserSeeTheScore(canOrNot: String, file: StaticString = #file, line: UInt = #line) {
        let scoreValueView = app.staticTexts["dashboard_view_score_value_label"]
        let value = scoreValueView.label
        
        let maximumView = app.staticTexts["dashboard_view_maximum_label"]
        let max = maximumView.label

        if canOrNot == "can" {
            XCTAssert(value == "514", "User cannot see the incorrect value: \(value)", file: file, line: line)
            XCTAssert(max == "out of 700", "User cannot see the incorrect maximum: \(max)", file: file, line: line)
        } else {
            XCTAssert(value == "-", "User cannot see the incorrect value: \(value)", file: file, line: line)
            XCTAssert(max == "unavailable. Try again later!", "User cannot see the incorrect maximum: \(max)", file: file, line: line)
        }
    }
}
