// 
//  DashboardPresenterSpec.swift
//  DonutViewTests
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

@testable import DonutView
import Nimble
import Quick

class DashboardPresenterSpec: QuickSpec {
    var mockView: MockDashboardView!
    var mockRouter: MockDashboardRouter!
    var mockInteractor: MockDashboardInteractor!
    var presenter: DashboardPresenter!
    
    override func spec() {
        beforeEach {
            self.mockView = MockDashboardView()
            self.mockRouter = MockDashboardRouter()
            self.mockInteractor = MockDashboardInteractor()

            self.presenter = DashboardPresenter(interactor: self.mockInteractor, router: self.mockRouter)
            self.presenter.view = self.mockView
        }
        describe("DashboardPresenterSpec") {
            it("configures view with score") {
                let credit = Credit.fakeCredit!
                
                self.mockInteractor.stubbedCreditCompletionHandlerResult = (.success(credit), ())
                self.presenter.viewIsReady()

                expect(self.mockInteractor.invokedCredit) == true
                expect(self.mockView.invokedSetupProgressState).toEventually(equal(true))
                expect(self.mockView.invokedSetupProgressStateParameters?.score).toEventually(equal(514))
                expect(self.mockView.invokedSetupProgressStateParameters?.maximumValue).toEventually(equal(700))
            }
            
            it("configures view to show error") {
                self.mockInteractor.stubbedCreditCompletionHandlerResult = (.failure(.networking(NetworkingServiceError.noNetwork)), ())
                self.presenter.viewIsReady()

                expect(self.mockInteractor.invokedCredit) == true
                expect(self.mockView.invokedShowError).toEventually(equal(true))
            }
        }
    }
}

class MockDashboardInteractor: DashboardInteractorInput {
    var invokedCredit = false
    var invokedCreditCount = 0
    var stubbedCreditCompletionHandlerResult: (Result<Credit, DashboardInteractorErrors>, Void)?
    
    func credit(completionHandler: @escaping (Result<Credit, DashboardInteractorErrors>) -> Void) {
        invokedCredit = true
        invokedCreditCount += 1
        
        if let result = stubbedCreditCompletionHandlerResult {
            completionHandler(result.0); return
        }
        
        completionHandler(.failure(.networking(NetworkingServiceError.noNetwork)))
    }
}

class MockDashboardRouter: DashboardRouterInput {
    static func build(from coordinator: CoordinatorInput, services: DashboardServices) -> UIViewController {
        fatalError("Dummy implementation")
    }
}

class MockDashboardView: DashboardViewInput {
    var invokedSetupProgressState = false
    var invokedSetupProgressStateCount = 0
    var invokedSetupProgressStateParameters: (score: Int, maximumValue: Int, Void)?
    var invokedSetupProgressStateParametersList = [(score: Int, maximumValue: Int, Void)]()
    
    func setupProgressState(with score: Int, and maximumValue: Int) {
        invokedSetupProgressState = true
        invokedSetupProgressStateCount += 1
        invokedSetupProgressStateParameters = (score, maximumValue, ())
        invokedSetupProgressStateParametersList.append((score, maximumValue, ()))
    }
    
    var invokedShowError = false
    var invokedShowErrorCount = 0
    
    func showErrors() {
        invokedShowError = true
        invokedShowErrorCount += 1
    }
}
