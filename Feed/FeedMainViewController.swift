//
//  ViewController.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import UIKit
import MJRefresh

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
    
    // For implementing paging function, define a variable for page.
    var pageNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        
        self.updateData()
    }
    
    // Function to configure table view.
    func configureTableView() {
        self.itemTableView.delegate = self
        self.itemTableView.dataSource = self
        
        // Add drag down function to the table view
        let header = MJRefreshNormalHeader.init { [weak self] in
            self?.dragDownRefresh()
        }
        header?.setTitle("Release to refresh.", for: .pulling)
        header?.setTitle("Refreshing...", for: .refreshing)
        self.itemTableView.mj_header = header
        
        // Add Pull up function to the table view
        let footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.updateData()
            
        })
        footer?.setTitle("Release to load more.", for: .pulling)
        footer?.setTitle("Loading more ...", for: .refreshing)
        self.itemTableView.mj_footer = footer
    }
    
    // Table view drag down to refresh the table
    func dragDownRefresh() {
        // reset the page number to zero
        self.pageNum = 0
        service.fetchList(forPageNum: pageNum) { (itemList, err) in
            guard let itemList = itemList else{
                return
            }
            // Update the source data
            self.feedItemList = itemList
            // Reload the table view
            self.itemTableView.reloadData()

            if self.itemTableView.mj_header.isRefreshing{
                self.itemTableView.mj_header.endRefreshing()
            }
        }
    }

    // Fetch data from server and rerender the view.
    // It will be call when the setup phrase or the pull up action.
    func updateData() {
        service.fetchList(forPageNum: pageNum) { (itemList, err) in
            guard let itemList = itemList else{
                return
            }
            // Update the source data
            self.feedItemList.append(contentsOf: itemList)
            // Reload the table view
            self.itemTableView.reloadData()
            
            // pageNum plus 1
            self.pageNum = self.pageNum + 1
            
            if self.itemTableView.mj_footer.isRefreshing{
                self.itemTableView.mj_footer.endRefreshing()
            }
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
            
            // tmp
            let editingVC = storyBoard.instantiateViewController(withIdentifier: "FeedEditingViewController") as! FeedEditingViewController
            editingVC.setItem(item: item.deepCopy())
            // Set callback function when the editing is done.
            editingVC.callBack = { (newItem) -> Void in
                self.feedItemList[path.row] = newItem
                tableView.reloadRows(at: [path], with: .fade)
            }
            self.navigationController?.pushViewController(editingVC, animated: true)
        }
        
        return [editAction, deleteAction]
    }
    
    // Return the calculated cell height.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.feedItemList[indexPath.row]
        return item.cellHeight
    }
    
    
    
    
}

