// 
//  DashboardInteractorSpec.swift
//  DonutViewTests
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

@testable import DonutView
import Nimble
import Quick

class DashboardInteractorSpec: QuickSpec {
    var mockNetworking: MockDashboardNetworking!
    var interactor: DashboardInteractor!
    
    override func spec() {
        beforeEach {
            self.mockNetworking = MockDashboardNetworking()

            let mockServices = DashboardServices(networking: self.mockNetworking)
            let output = MockDashboardInteractorOutput()

            self.interactor = DashboardInteractor()
            self.interactor.services = mockServices
            self.interactor.output = output
        }
        
        describe("DashboardInteractorSpec") {
            it("fetch credit") {
                let expectedResult: Credit = Credit.fakeCredit!
                self.mockNetworking.stubbedCreditCompletionHandlerResult = (.success(expectedResult) ,())

                var actualResult: Credit?
                self.interactor.credit { result in
                    switch result {
                    case let .success(credit): actualResult = credit
                    case .failure: XCTFail("Credit request shouldn't fail")
                    }
                }

                expect(self.mockNetworking.invokedCredit) == true
                expect(actualResult).toEventually(equal(expectedResult))
            }
            
            it("fails to fetch credit") {
                self.mockNetworking.stubbedCreditCompletionHandlerResult = (.failure(.noNetwork) ,())

                let expectedResult: DashboardInteractorErrors = .networking(NetworkingServiceError.noNetwork)
                var actualResult: DashboardInteractorErrors?
                self.interactor.credit { result in
                    switch result {
                    case .success: XCTFail("Credit request shouldn't success")
                    case let .failure(error): actualResult = error
                    }
                }

                expect(self.mockNetworking.invokedCredit) == true
                expect(actualResult?.localizedDescription).toEventually(equal(expectedResult.localizedDescription))
            }
        }
    }
}

class MockDashboardInteractorOutput: DashboardInteractorOutput {}
