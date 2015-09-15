//
//  PugsController.swift
//  Pugs
//
//  Created by Sam Soffes on 9/14/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import Foundation

protocol PugsControllerDelegate: class {
	func pugsController(controller: PugsController, didAddImageURLs imageURLs: [NSURL])
}

class PugsController {

	// MARK: - Properties

	weak var delegate: PugsControllerDelegate?

	var imageURLs = [NSURL]()

	private(set) var loading = false

	private let session: NSURLSession


	// MARK: - Initializers

	init(delegate: PugsControllerDelegate? = nil, session: NSURLSession = NSURLSession.sharedSession()) {
		self.delegate = delegate
		self.session = session
	}


	// MARK: - Fetching

	func fetch() {
		if loading {
			return
		}

		guard let URL = NSURL(string: "https://pugme.herokuapp.com/bomb?count=50") else { return }
		loading = true

		let request = NSURLRequest(URL: URL)
		session.dataTaskWithRequest(request) { [weak self] data, _, _ in
			guard let data = data,
				json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
				dictionary = json as? [String: AnyObject],
				strings = dictionary["pugs"] as? [String]
			else {
				dispatch_async(dispatch_get_main_queue()) {
					self?.loading = false
				}
				return
			}

			// Sanitize and convert to URLs
			let URLs = strings.flatMap { $0.componentsSeparatedByString("\"").first }.flatMap { NSURL(string: $0) }

			guard let controller = self else { return }
			dispatch_async(dispatch_get_main_queue()) {
				controller.imageURLs += URLs
				controller.loading = false
				controller.delegate?.pugsController(controller, didAddImageURLs: URLs)
			}
		}.resume()
	}
}
