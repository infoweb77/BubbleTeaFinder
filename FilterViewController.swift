//
//  FilterViewController.swift
//  BubbleTeaFinder
//
//  Created by alex on 21/09/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit
import CoreData


protocol FilterViewControllerDelegate: class {
    func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?)
}

let filterCellIdentifier = "filterCell"

class FilterViewController: UITableViewController {
    
    // Predicats
    lazy var cheapShopPredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$")
        return predicate
    }()
    
    lazy var moderateShopPredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$$")
        return predicate
    }()
    
    lazy var expensiveShopPredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$$$")
        return predicate
    }()
    
    lazy var offeringDealPredicate: NSPredicate = {
        var predicate = NSPredicate(format: "specialCount > 0")
        return predicate
    }()
    
    lazy var walkingDistancePredicate: NSPredicate = {
        var predicate = NSPredicate(format: "location.distance < 500")
        return predicate
    }()
    
    lazy var hasUserTipsPredicate: NSPredicate = {
        var predicate = NSPredicate(format: "stats.tipCount > 0")
        return predicate
    }()
    
    
    // Sort descriptors
    lazy var nameSortDescriptor: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "name", ascending: true, selector: "localizedStandardCompare:")
        return sd
    }()
    
    lazy var distanceSortDescriptor: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "location.distance", ascending: true)
        return sd
    }()
    
    lazy var priceSortDescriptor: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "priceInfo.priceCategory", ascending: true)
        return sd
    }()
    
    
    var coreDataStack: CoreDataStack!
    
    weak var delegate: FilterViewControllerDelegate?
    var selectedSortDescriptor: NSSortDescriptor?
    var selectedPredicate: NSPredicate?

    var firstPriceCategoryCount = 0
    var secondPriceCategoryCount = 0
    var thirdPriceCategoryCount = 0
    
    var dealsCount = 0
    
    
    // MARK - ViewController lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        
        setupNavigation()
        
        populateCheapShopCount()
        populateModerateShopCount()
        populateExpensiveShopCount()
        populateDealsCount()
        
        setupTableView()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Filters"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(backPerformAction(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .Plain, target: self, action: #selector(searchPerformAction(_:)))
    }
    
    private func setupTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .Grouped)
        if let theTableView = self.tableView {
            
            theTableView.registerClass(FilterTableViewCell.self, forCellReuseIdentifier: filterCellIdentifier)
            
            theTableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            
            theTableView.delegate = self
            theTableView.dataSource = self
        }
    }
    
    @objc func backPerformAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc func searchPerformAction(sender: UIBarButtonItem) {
        delegate!.filterViewController(self, didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK - UITableViewDataSource methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 4
        }
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(filterCellIdentifier, forIndexPath: indexPath) as! FilterTableViewCell
        
        cell.selectionStyle = .None
        
        var mainText: String!
        var detailText = ""
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            switch row {
            case 1:
                mainText = "$$"
                detailText = "\(secondPriceCategoryCount) bubble tea places"
            case 2:
                mainText = "$$$"
                detailText = "\(thirdPriceCategoryCount) bubble tea places"
            default:
                mainText = "$"
                detailText = "\(firstPriceCategoryCount) bubble tea places"
            }
        }
        else if section == 1 {
            switch row {
            case 1:
                mainText = "Within walking distance"
                detailText = "< 500 m"
            case 2:
                mainText = "Has user tips"
            default:
                mainText = "Offering a deal"
                detailText = "\(dealsCount) total deals"
            }
        }
        else if section == 2 {
            switch row {
            case 1:
                mainText = "Name (Z-A)"
            case 2:
                mainText = "Distance"
            case 3:
                mainText = "Price"
            default:
                mainText = "Name (A-Z)"
            }
        }
        
        cell.mainTextLabel.text = mainText!
        cell.detailedTextLabel.text = detailText
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "MOST POPULAR"
        case 2:
            return "SORT BY"
        default:
            return "PRICE"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    //MARK - UITableViewDelegate methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        uncheckCells(tableView, withIndexPath: indexPath)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = .Checkmark
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            switch row {
            case 1:
                selectedPredicate = moderateShopPredicate
            case 2:
                selectedPredicate = expensiveShopPredicate
            default:
                selectedPredicate = cheapShopPredicate
            }
        }
        else if section == 1 {
            switch row {
            case 1:
                selectedPredicate = walkingDistancePredicate
            case 2:
                selectedPredicate = hasUserTipsPredicate
            default:
                selectedPredicate = offeringDealPredicate
            }
        }
        else if section == 2 {
            switch row {
            case 1:
                selectedSortDescriptor = nameSortDescriptor.reversedSortDescriptor as? NSSortDescriptor
            case 2:
                selectedSortDescriptor = distanceSortDescriptor
            case 3:
                selectedSortDescriptor = priceSortDescriptor
            default:
                selectedSortDescriptor = nameSortDescriptor
            }
        }
    }
    
    private func uncheckCells(tableView: UITableView, withIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        if section == 2 {
            for (var j = 0; j < 4; j++) {
                let newIndexPath = NSIndexPath(forRow: j, inSection: 2)
                let cell = tableView.cellForRowAtIndexPath(newIndexPath)
                cell?.accessoryType = .None
            }
        }
        else {
            for(var i = 0; i < 2; i++) {
                for (var j = 0; j < 3; j++) {
                    let newIndexPath = NSIndexPath(forRow: j, inSection: i)
                    let cell = tableView.cellForRowAtIndexPath(newIndexPath)
                    cell?.accessoryType = .None
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 47
    }
    
    
    // MARK - Populate labels
    func populateCheapShopCount() {
        let fetchRequest = NSFetchRequest(entityName: "Shop")
        fetchRequest.resultType = .CountResultType
        fetchRequest.predicate = cheapShopPredicate
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [NSNumber]
            firstPriceCategoryCount = results.first!.integerValue
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func populateModerateShopCount() {
        let fetchRequest = NSFetchRequest(entityName: "Shop")
        fetchRequest.resultType = .CountResultType
        fetchRequest.predicate = moderateShopPredicate
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [NSNumber]
            secondPriceCategoryCount = results.first!.integerValue
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func populateExpensiveShopCount() {
        let fetchRequest = NSFetchRequest(entityName: "Shop")
        fetchRequest.predicate = expensiveShopPredicate
        
        var error: NSError?
        let count = coreDataStack.context.countForFetchRequest(fetchRequest, error: &error)
        
        if count != NSNotFound {
            thirdPriceCategoryCount = count
        }
        else {
            print("Could not fetch \(error), \(error?.userInfo)")
        }
    }
    
    func populateDealsCount() {
        let fetchRequest = NSFetchRequest(entityName: "Shop")
        fetchRequest.resultType = .DictionaryResultType
        
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumDeals"
        
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "specialCount")])
        sumExpressionDesc.expressionResultType = .Integer32AttributeType
        
        fetchRequest.propertiesToFetch = [sumExpressionDesc]
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [NSDictionary]
            let resultDict = results.first!
            dealsCount = resultDict["sumDeals"] as! Int
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}
















