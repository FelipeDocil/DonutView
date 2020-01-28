// 
//  DashboardViewSpec.swift
//  DonutViewTests
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

@testable import DonutView
import Nimble
import Quick
import SnapshotTesting
import SnapshotTesting_Nimble

class DashboardViewSpec: QuickSpec {
    override func spec() {
        describe("DashboardViewSpec") {
            beforeSuite {
                // Snapshots must be compared using a simulator with the same OS, device as the simulator that originally took the reference
                self.verifyDevice()
            }
            it("snapshot the initial view") {
                let mockPresenter = MockDashboardPresenter()
                
                let view = DashboardView(presenter: mockPresenter)

                let navigationController = UINavigationController(rootViewController: view)

                record = false
                expect(navigationController).to(haveValidSnapshot(as: .image(on: .iPhoneSe), named: "iPhoneSE"))
                expect(navigationController).to(haveValidSnapshot(as: .image(on: .iPhone8), named: "iPhone8"))
                expect(navigationController).to(haveValidSnapshot(as: .image(on: .iPhone8Plus), named: "iPhone8Plus"))
                expect(navigationController).to(haveValidSnapshot(as: .image(on: .iPhone11), named: "iPhone11"))
                expect(navigationController).to(haveValidSnapshot(as: .image(on: .iPhone11Pro), named: "iPhone11Pro"))
            }
            
            it("snapshot the view with score") {
                let mockPresenter = MockDashboardPresenter()
                
                let view = DashboardView(presenter: mockPresenter)
                let navigationController = UINavigationController(rootViewController: view)
                
                view.setupProgressState(with: 327, and: 700)

                record = false
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhoneSe), named: "iPhoneSE"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone8), named: "iPhone8"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone8Plus), named: "iPhone8Plus"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone11), named: "iPhone11"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone11Pro), named: "iPhone11Pro"))
            }
            
            it("snapshot the error view") {
                let mockPresenter = MockDashboardPresenter()
                
                let view = DashboardView(presenter: mockPresenter)
                let navigationController = UINavigationController(rootViewController: view)
                
                view.showErrors()
                
                record = false
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhoneSe), named: "iPhoneSE"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone8), named: "iPhone8"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone8Plus), named: "iPhone8Plus"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone11), named: "iPhone11"))
                expect(navigationController).toEventually(haveValidSnapshot(as: .image(on: .iPhone11Pro), named: "iPhone11Pro"))
            }
        }
    }
}

class MockDashboardPresenter: DashboardPresenterInput {
    var invokedViewIsReady = false
    var invokedViewIsReadyCount = 0

    func viewIsReady() {
        invokedViewIsReady = true
        invokedViewIsReadyCount += 1
    }
}
