//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by soheiln on 5/2/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource Protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableViewCell")!
        let row = indexPath.row
        cell.imageView!.image = memes[row].memedImage
        cell.textLabel!.text = memes[row].topText + "..." + memes[row].bottomText
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get memeDetailVC
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let memeDetailVC = object as! MemeDetailViewController
        

        // Populate memeDetailVC with data from selected item
        let dummyVarToLoadNibFile = memeDetailVC.view
        memeDetailVC.imageView.image = memes[indexPath.row].memedImage

        // Push the VC to navigationController
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
//        self.presentViewController(memeDetailVC, animated: true, completion: nil)
    }
    
}
