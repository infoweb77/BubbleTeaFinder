//
//  ViewController.swift
//  BubbleTeaFinder
//
//  Created by alex on 16/09/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit
import CoreData

let mainCellIdentifier = "mainTableViewCell"

class ViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    
    var fetchRequest: NSFetchRequest!
    var asyncFetchRequest: NSAsynchronousFetchRequest!
    
    var shops: [Shop]! = []
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        
        setupData()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Bubble Tea!"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: #selector(filterViewPerformAction(_:)))
    }
    
    private func setupTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .Plain)
        if let theTableView = self.tableView {
            
            theTableView.registerClass(MainTableViewCell.self, forCellReuseIdentifier: mainCellIdentifier)
            
            theTableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            
            theTableView.delegate = self
            theTableView.dataSource = self
        }
        view.addSubview(tableView)
    }
    
    private func setupData() {
        fetchRequest = NSFetchRequest(entityName: "Shop")
        
        asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            [unowned self] (result: NSAsynchronousFetchResult!) -> Void in
            
            self.shops = result.finalResult as! [Shop]
            self.tableView.reloadData()
        }
        
        do {
            try coreDataStack.context.executeRequest(asyncFetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func fetchAndReload() {
        do {
            shops = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Shop]
            tableView.reloadData()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    @objc func filterViewPerformAction(sender: UIBarButtonItem) {
        let filtersVC = FilterViewController()
        filtersVC.coreDataStack = coreDataStack
        filtersVC.delegate = self
        
        let navController = UINavigationController(rootViewController: filtersVC)
        self.presentViewController(navController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops?.count > 0 ? shops.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(mainCellIdentifier, forIndexPath: indexPath) as! MainTableViewCell
        
        cell.selectionStyle = .None
        
        let shop = shops[indexPath.row]
        
        cell.mainTextLabel.text = shop.name
        cell.detailedTextLabel.text = shop.priceInfo?.priceCategory
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let shop = shops[indexPath.row]
        
        let detailVC = DetailViewController(shop: shop)
        let navController = UINavigationController(rootViewController: detailVC)
        self.presentViewController(navController, animated: true, completion: nil)
    }
}

// MARK - FilterViewControllerDelegate methods
extension ViewController: FilterViewControllerDelegate {
    func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?,
                              sortDescriptor: NSSortDescriptor?) {
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        if let fetchPredicate = predicate {
            fetchRequest.predicate = fetchPredicate
        }
        if let sr = sortDescriptor {
            fetchRequest.sortDescriptors = [sr]
        }
        
        fetchAndReload()
    }
}


