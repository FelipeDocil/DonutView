//
//  SceneDelegate.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: CoordinatorInput?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard
            let windowScene = (scene as? UIWindowScene)
        else { return }

        coordinator = Coordinator()
        let controller = coordinator?.buildRoot()
        let navigation = UINavigationController(rootViewController: controller!) // If it couldn't build Root it has to crash, there is no possible fallback for that

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigation
        window.backgroundColor = .white

        self.window = window
        window.makeKeyAndVisible()
    }
}
