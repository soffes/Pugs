//
//  ImagesController.swift
//  Pugs
//
//  Created by Sam Soffes on 9/14/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

private let sharedImagesController = ImagesController()

class ImagesController {

	// MARK: - Types

	typealias Completion = UIImage? -> Void


	// MARK: - Properties

	static var sharedController: ImagesController {
		return sharedImagesController
	}

	private let cache = NSCache()
	private var fetching = [NSURL: [Completion]]()


	// MARK: - Fetching

	func fetch(imageURL: NSURL, completion: Completion) {
		if var completions = fetching[imageURL] {
			completions.append(completion)
			fetching[imageURL] = completions
			return
		}

		fetching[imageURL] = [completion]

		let key = imageURL.absoluteString
		if let cachedImage = cache.objectForKey(key) as? UIImage {
			dispatch_async(dispatch_get_main_queue()) { [weak self] in
				self?.fetching[imageURL]?.forEach { $0(cachedImage) }
				self?.fetching[imageURL] = nil
			}
			return
		}

		NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: imageURL)) { [weak self] data, _, _ in
			let image = data.flatMap {  UIImage(data: $0) }

			if let image = image {
				self?.cache.setObject(image, forKey: key)
			}

			dispatch_async(dispatch_get_main_queue()) {
				self?.fetching[imageURL]?.forEach { $0(image) }
				self?.fetching[imageURL] = nil
			}
		}.resume()
	}
}
