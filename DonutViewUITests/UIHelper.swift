//
//  UIHelper.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import XCTest

extension XCTestCase {
    func launchApp(arguments: [String] = []) {
        let app = XCUIApplication()
        app.launchEnvironment[Arguments.uiTest.rawValue] = "true"
        
        app.launchArguments.append(contentsOf: arguments)
        app.launch()
    }
}

extension XCUIElement {
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
