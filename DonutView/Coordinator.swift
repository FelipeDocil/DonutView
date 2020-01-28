//
//  Coordinator.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import UIKit

protocol CoordinatorInput: AnyObject {
    func buildRoot() -> UIViewController
}

protocol CoordinatorBuilder {
    var networkingService: NetworkingServiceInput { get }
}

class Coordinator: CoordinatorInput, CoordinatorBuilder {
    
    lazy var networkingService: NetworkingServiceInput = NetworkingService()
    
    func buildRoot() -> UIViewController {
        return buildDashboard()
    }
}

// - MARK: Builder

extension CoordinatorBuilder where Self: CoordinatorInput {
    func buildDashboard() -> UIViewController {
        let services = DashboardServices(networking: networkingService)
        let list = DashboardRouter.build(from: self, services: services)
        
        return list
    }
}
