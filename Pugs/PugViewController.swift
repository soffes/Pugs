//
//  PugViewController.swift
//  Pugs
//
//  Created by Sam Soffes on 9/14/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

class PugViewController: UIViewController {

	// MARK: - Properties

	let imageURL: NSURL

	private let imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .ScaleAspectFit
		view.clipsToBounds = true
		return view
	}()


	// MARK: - Initializers

	init(imageURL: NSURL) {
		self.imageURL = imageURL
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}


	// MARK: - UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Pug"
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "close:")
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "share:")

		view.backgroundColor = .blackColor()
		view.addSubview(imageView)

		NSLayoutConstraint.activateConstraints([
			NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
		])

		NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: imageURL)) { [weak self] data, _, _ in
			guard let data = data else { return }
			dispatch_async(dispatch_get_main_queue()) {
				self?.imageView.image = UIImage(data: data)
			}
		}.resume()
	}


	// MARK: - Actions

	@objc private func close(sender: AnyObject?) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	@objc private func share(sender: AnyObject?) {
		let viewController = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
		presentViewController(viewController, animated: true, completion: nil)
	}
}
