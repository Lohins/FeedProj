//
//  ViewController.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import UIKit

/*
 The class works as the entrance of the application.
 Its main content is a table view.
 */

class FeedMainViewController: UIViewController {
    
    // Initialize service object.
    let service = ListFetchService.init()

    // UI Properties.
    @IBOutlet var itemTableView: UITableView!
    
    // Data Properties
    var feedItemList:[FeedItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        
        self.updateData()
    }
    
    // Function to configure table view.
    func configureTableView() {
        self.itemTableView.delegate = self
        self.itemTableView.dataSource = self
    }

    // Fetch data from server and rerender the view.
    func updateData() {
        service.fetchList(forPageNum: 0) { (itemList, err) in
            guard let itemList = itemList else{
                return
            }
            // Update the source data
            self.feedItemList = itemList
            // Reload the table view
            self.itemTableView.reloadData()
        }
    }
}


/*
 UITableView delegation methods.
 */
extension FeedMainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse cell with identifier and lower cast to FeedItemTBC class.
        let cell  = tableView.dequeueReusableCell(withIdentifier: "FeedItemTBC", for: indexPath) as! FeedItemTBC
        
        // Get feed item and initialize the cell.
        let item = self.feedItemList[indexPath.row]
        cell.setItem(item: item, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    
    // Create edit and delete actions.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "Delete") { (action, path) in
            let row = path.row
            self.feedItemList.remove(at: row)
            self.itemTableView.deleteRows(at: [path], with: .fade)
        }
        
        let editAction = UITableViewRowAction.init(style: .normal, title: "Edit") { (action, path) in
            let item = self.feedItemList[path.row]
            // push up view controller for editing.
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let editViewController = storyBoard.instantiateViewController(withIdentifier: "FeedEditViewController") as! FeedEditViewController
            editViewController.setItem(item: item.deepCopy())
            // Set callback function when the editing is done.
            editViewController.callBack = { (newItem) -> Void in
                self.feedItemList[path.row] = newItem
                tableView.reloadRows(at: [path], with: .fade)
            }
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
        
        return [editAction, deleteAction]
    }
    
    // Return the calculated cell height.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.feedItemList[indexPath.row]
        return item.cellHeight
    }
    
    
    
}

