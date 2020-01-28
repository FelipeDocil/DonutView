//
//  UITestArguments.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import Foundation

enum Arguments: String {
    case uiTest

    enum Initial: String {
        case dashboard
    }

    enum Networking: String {
        case noNetwork
        case success
    }
}
