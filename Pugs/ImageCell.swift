//
//  ImageCell.swift
//  Pugs
//
//  Created by Sam Soffes on 9/14/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: class {
	func imageCell(imageCell: ImageCell, shouldShowImageURL imageURL: NSURL)
	func imageCell(imageCell: ImageCell, shouldCopyImageURL imageURL: NSURL)
}

class ImageCell: UICollectionViewCell {

	// MARK: - Properties

	weak var delegate: ImageCellDelegate?

	var imageURL: NSURL? {
		didSet {
			imageView.image = nil
			guard let URL = imageURL else { return }

			ImagesController.sharedController.fetch(URL) { [weak self] image in
				if let imageURL = self?.imageURL where imageURL == URL {
					self?.imageView.image = image
				}
			}
		}
	}

	private let imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .ScaleAspectFill
		view.clipsToBounds = true
		return view
	}()


	// MARK: - Initializers

	override init(frame: CGRect) {
		super.init(frame: frame)

		contentView.backgroundColor = UIColor(white: 0.1, alpha: 1)
		contentView.addSubview(imageView)

		NSLayoutConstraint.activateConstraints([
			NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .Leading, multiplier: 1, constant: 0)
		])

		contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap:"))
		contentView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Actions

	@objc private func tap(sender: AnyObject?) {
		guard let imageURL = imageURL else { return }
		delegate?.imageCell(self, shouldShowImageURL: imageURL)
	}

	@objc private func longPress(sender: AnyObject?) {
		guard let imageURL = imageURL else { return }
		delegate?.imageCell(self, shouldCopyImageURL: imageURL)
	}
}
