//
//  FakeSceneDelegate.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import UIKit

// Entities

extension Credit {
    static var fakeCredit: Credit? {
        guard let path = Bundle.main.path(forResource: "fake_credit", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: path)

        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else { return nil }

        let decoder = JSONDecoder()
        let credit = try! decoder.decode(Credit.self, from: data)

        return credit
    }
}

// Services

class MockNetworking: NetworkingServiceInput {

    func credit(completionHandler: @escaping (Result<Credit, NetworkingServiceError>) -> Void) {
        let arguments = ProcessInfo.processInfo.arguments

        if arguments.contains(Arguments.Networking.noNetwork.rawValue) { completionHandler(.failure(.noNetwork)); return }
        if arguments.contains(Arguments.Networking.success.rawValue) {
            guard let credit = Credit.fakeCredit else { completionHandler(.failure(.noNetwork)); return }
            completionHandler(.success(credit))
            return
        }

        completionHandler(.failure(.noNetwork))
    }
}

// Coordinator

class MockCoordinator: CoordinatorInput, CoordinatorBuilder {

    lazy var networkingService: NetworkingServiceInput = MockNetworking()

    func buildRoot() -> UIViewController {
        let arguments = ProcessInfo.processInfo.arguments
        var controller: UIViewController = UIViewController()

        if arguments.contains(Arguments.Initial.dashboard.rawValue) { controller = buildDashboard() }

        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
}

// SceneDelegate

class FakeSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: CoordinatorInput?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard
            let windowScene = (scene as? UIWindowScene)
        else { return }

        coordinator = MockCoordinator()
        let controller = coordinator?.buildRoot()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = controller
        window.backgroundColor = .white

        self.window = window
        window.makeKeyAndVisible()
    }
}
