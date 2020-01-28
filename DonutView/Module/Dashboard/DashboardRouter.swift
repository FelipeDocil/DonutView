// 
//  DashboardRouter.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import UIKit

class DashboardServices {
    var networking: NetworkingServiceInput

    init(networking: NetworkingServiceInput) {
        self.networking = networking
    }
}

protocol DashboardRouterOutput: AnyObject {}

protocol DashboardRouterInput: AnyObject {
    static func build(from coordinator: CoordinatorInput, services: DashboardServices) -> UIViewController
}

class DashboardRouter: DashboardRouterInput {
    weak var viewController: UIViewController?
    weak var output: DashboardRouterOutput?

    struct Dependencies {
        weak var coordinator: CoordinatorInput?
        weak var services: DashboardServices?
    }

    private var dependencies: Dependencies

    private init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: DashboardRouterInput

    static func build(from coordinator: CoordinatorInput, services: DashboardServices) -> UIViewController {
        let dependencies = Dependencies(coordinator: coordinator, services: services)

        // VIPER classes

        let router = DashboardRouter(dependencies: dependencies)
        let interactor = DashboardInteractor()
        let presenter = DashboardPresenter(interactor: interactor, router: router)
        let view = DashboardView(presenter: presenter)
        
        router.output = presenter
        router.viewController = view
        interactor.output = presenter
        interactor.services = dependencies.services
        presenter.view = view

        return view
    }
}
