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
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        print("in MemeTableViewVC's View will appear") //TODO:cleanup
    }
    
    // MARK: UITableViewDataSource Protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in numberOfRows... View will appear") //TODO:cleanup
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("in cellforrow... View will appear") //TODO:cleanup

        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")!
        let row = indexPath.row
        cell.imageView!.image = memes[row].memedImage
        cell.textLabel!.text = memes[row].topText + "..." + memes[row].bottomText
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: open MemeEditorVC with the selected meme
    }
    
}
