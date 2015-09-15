//
//  AppDelegate.swift
//  Pugs
//
//  Created by Sam Soffes on 9/14/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

	// MARK: - Properties

	var window: UIWindow? = {
		let window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window.rootViewController = UINavigationController(rootViewController: PugsViewController())
		return window
	}()
}


extension AppDelegate: UIApplicationDelegate {
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		let navigationBar = UINavigationBar.appearance()
		navigationBar.barStyle = .Black
		navigationBar.tintColor = UIColor(white: 1, alpha: 0.6)

		window?.makeKeyAndVisible()
		return true
	}
}
