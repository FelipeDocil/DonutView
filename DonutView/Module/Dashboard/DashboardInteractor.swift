// 
//  DashboardInteractor.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

enum DashboardInteractorErrors: Error {
    case networking(Error)
}

protocol DashboardInteractorInput: AnyObject {
    func credit(completionHandler: @escaping (Result<Credit, DashboardInteractorErrors>) -> Void)
}

protocol DashboardInteractorOutput: AnyObject {}

class DashboardInteractor: DashboardInteractorInput {
    weak var output: DashboardInteractorOutput?
    var services: DashboardServices?

    // MARK: DashboardInteractorInput
    
    func credit(completionHandler: @escaping (Result<Credit, DashboardInteractorErrors>) -> Void) {
        services?.networking.credit { result in
            switch result {
            case let .failure(error): completionHandler(.failure(.networking(error))); return
            case let .success(credit): completionHandler(.success(credit))
            }
        }
    }
}
