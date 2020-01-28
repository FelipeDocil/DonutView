// 
//  DashboardRouterSpec.swift
//  DonutViewTests
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

@testable import DonutView
import Nimble
import Quick

class DashboardRouterSpec: QuickSpec {
    override func spec() {
        describe("DashboardRouterSpec") {
            it("configures the module") {
                let coordinator = MockDashboardCoordinator()

                let mockServices = DashboardServices(networking: MockDashboardNetworking())

                let module = DashboardRouter.build(from: coordinator, services: mockServices)
                
                let view = module as? DashboardView
                let presenter = view?.presenter as? DashboardPresenter
                let router = presenter?.router as? DashboardRouter
                let interactor = presenter?.interactor as? DashboardInteractor

                expect(view).notTo(beNil())
                expect(presenter).notTo(beNil())
                expect(presenter?.view).notTo(beNil())
                expect(router).notTo(beNil())
                expect(router?.output).notTo(beNil())
                expect(router?.viewController).notTo(beNil())
                expect(interactor).notTo(beNil())
                expect(interactor?.output).notTo(beNil())
                expect(interactor?.services).notTo(beNil())
            }
        }
    }
}

class MockDashboardCoordinator: CoordinatorInput {
    var stubbedNavigationController: UINavigationController = UINavigationController()
    var navigationController: UINavigationController
    
    init() {
        navigationController = stubbedNavigationController
    }
       
    func buildRoot() -> UIViewController {
        fatalError("Dummy implementation")
    }
}

class MockDashboardNetworking: NetworkingServiceInput {
    var invokedCredit = false
    var invokedCreditCount = 0
    var stubbedCreditCompletionHandlerResult: (Result<Credit, NetworkingServiceError>, Void)?
    
    func credit(completionHandler: @escaping (Result<Credit, NetworkingServiceError>) -> Void) {
        invokedCredit = true
        invokedCreditCount += 1
        
        if let result = stubbedCreditCompletionHandlerResult {
            completionHandler(result.0); return
        }
        
        completionHandler(.failure(.noNetwork))
    }
}
