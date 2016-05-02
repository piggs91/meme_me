//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by soheiln on 5/2/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let space: CGFloat = 3.0
        let numSection = 3.0
        let dimension = min((self.view.frame.size.width - (CGFloat(numSection-1) * space)) / CGFloat(numSection),
            (self.view.frame.size.height - (CGFloat(numSection-1) * space)) / CGFloat(numSection))
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource Protocol
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.imageView?.image = memes[indexPath.item].memedImage
        cell.topText?.text = memes[indexPath.item].topText
        cell.bottomText?.text = memes[indexPath.item].bottomText
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO: open MemeEditorVC with the selected meme
        
    }
    
}
