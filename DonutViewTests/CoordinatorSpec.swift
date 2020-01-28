//
//  CoordinatorSpec.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

@testable import DonutView
import Nimble
import Quick
import CoreData

class CoordinatorSpec: QuickSpec {
    override func spec() {
        describe("CoordinatorSpec") {
            it("configures root controller") {
                let coordinator = Coordinator()
                
                let root = coordinator.buildRoot()
                let navigationController = UINavigationController(rootViewController: root)
                
                expect(navigationController.topViewController).to(beAKindOf(DashboardView.self))
                expect(navigationController.viewControllers.count) == 1
            }
        }
    }
}
