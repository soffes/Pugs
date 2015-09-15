//
//  PugsViewController.swift
//  Pugs
//
//  Created by Sam Soffes on 9/14/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

class PugsViewController: UICollectionViewController {

	// MARK: - Properties

	let pugsController = PugsController()


	// MARK: - Initializers

	convenience init() {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
		self.init(collectionViewLayout: layout)
	}


	// MARK: - UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Pugs"
		view.backgroundColor = .blackColor()

		collectionView?.registerClass(ImageCell.self, forCellWithReuseIdentifier: "Image")

		pugsController.delegate = self
		pugsController.fetch()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		let dimension = round((view.bounds.width - 3) / 4)

		layout?.itemSize = CGSize(width: dimension, height: dimension)
	}
	

	// MARK: - UICollectionViewDataSource

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pugsController.imageURLs.count
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Image", forIndexPath: indexPath) as? ImageCell else {
			return UICollectionViewCell()
		}

		cell.imageURL = pugsController.imageURLs[indexPath.row]
		cell.delegate = self

		return cell
	}


	// MARK: - UICollectionViewDelegate

	override func scrollViewDidScroll(scrollView: UIScrollView) {
		// If within half a screen of the bottom, load more.
		guard scrollView.contentOffset.y + scrollView.bounds.height > scrollView.contentSize.height - view.bounds.height / 2 else { return }

		pugsController.fetch()
	}
}


extension PugsViewController: PugsControllerDelegate {
	func pugsController(controller: PugsController, didAddImageURLs imageURLs: [NSURL]) {
		let end = controller.imageURLs.count
		let start = end - imageURLs.count

		var indexPaths = [NSIndexPath]()
		for i in start..<end {
			indexPaths.append(NSIndexPath(forItem: i, inSection: 0))
		}

		collectionView?.performBatchUpdates({
			self.collectionView?.insertItemsAtIndexPaths(indexPaths)
		}, completion: nil)
	}
}


extension PugsViewController: ImageCellDelegate {
	func imageCell(imageCell: ImageCell, shouldShowImageURL imageURL: NSURL) {
		let viewController = PugViewController(imageURL: imageURL)
		presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
	}

	func imageCell(imageCell: ImageCell, shouldCopyImageURL imageURL: NSURL) {
		UIPasteboard.generalPasteboard().URL = imageURL

		// Show confirmation
		let alert = UIAlertController(title: "Copied!", message: nil, preferredStyle: .Alert)
		presentViewController(alert, animated: true) {

			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) {
				alert.dismissViewControllerAnimated(true, completion: nil)
			}
		}
	}
}
