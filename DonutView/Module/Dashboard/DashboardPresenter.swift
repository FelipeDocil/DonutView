// 
//  DashboardPresenter.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

protocol DashboardPresenterInput: AnyObject {
    func viewIsReady()
}

class DashboardPresenter: DashboardPresenterInput, DashboardInteractorOutput, DashboardRouterOutput {
    weak var view: DashboardViewInput?
    var interactor: DashboardInteractorInput
    var router: DashboardRouterInput

    init(interactor: DashboardInteractorInput, router: DashboardRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: DashboardPresenterInput

    func viewIsReady() {
        fetchScore()
    }
    
    // MARK: Private methods
    private func fetchScore() {
        interactor.credit { result in
            switch result {
            case .failure: self.view?.showErrors()
            case let .success(credit):
                self.view?.setupProgressState(with: credit.score, and: credit.maxScoreValue)
            }
        }
    }
}
