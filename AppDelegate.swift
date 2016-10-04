//
//  AppDelegate.swift
//  BubbleTeaFinder
//
//  Created by alex on 16/09/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        importJSONSeedDataIfNeeded()
        
        let navController = window!.rootViewController as! UINavigationController
        let viewController = navController.topViewController as! ViewController
        viewController.coreDataStack = coreDataStack
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        coreDataStack.saveContext()
    }

    // MARK - JSON Data
    func importJSONSeedDataIfNeeded() {
        let fetchRequest = NSFetchRequest(entityName: "Shop")
        var error: NSError? = nil
        
        let results = coreDataStack.context.countForFetchRequest(fetchRequest, error: &error)
        if results == 0 {
            do {
                let results = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Shop]
                
                for object in results {
                    let team = object as Shop
                    coreDataStack.context.deleteObject(team)
                }
                
                coreDataStack.saveContext()
                importJSONSeedData()
            }
            catch let error as NSError {
                print("Error fetching: \(error.localizedDescription)")
            }
        }
    }
    
    func importJSONSeedData() {
        
        let currentContext = coreDataStack.context
        
        let jsonURL = NSBundle.mainBundle().URLForResource("seed", withExtension: "json")
        let jsonData = NSData(contentsOfURL: jsonURL!)
        
        let shopEntity      = NSEntityDescription.entityForName("Shop", inManagedObjectContext: currentContext)
        let locationEntity  = NSEntityDescription.entityForName("Location", inManagedObjectContext: currentContext)
        let categoryEntity  = NSEntityDescription.entityForName("Category", inManagedObjectContext: currentContext)
        let priceEntity     = NSEntityDescription.entityForName("PriceInfo", inManagedObjectContext: currentContext)
        let statsEntity     = NSEntityDescription.entityForName("Stats", inManagedObjectContext: currentContext)
        
        do {
            let json = JSON(data: jsonData!)
            let dataArray = json["response"]["venues"].array
            
            for item in dataArray! {
                let shopName     = item["name"].string
                let shopPhone    = item["contact"]["formattedPhone"].string
                let specialCount = item["specials"]["count"].number
                
                let locationDict = item["location"].dictionary
                let priceDict    = item["price"].dictionary
                let statsDict    = item["stats"].dictionary
                
                let location = Location(entity: locationEntity!, insertIntoManagedObjectContext: currentContext)
                location.address     = (locationDict!["address"] != nil) ? locationDict!["address"]?.string : ""
                location.crossStreet = (locationDict!["crossStreet"] != nil) ? locationDict!["crossStreet"]?.string : ""
                location.city        = (locationDict!["city"] != nil) ? locationDict!["city"]?.string : ""
                location.distance    = locationDict!["distance"]?.float
                location.lat         = locationDict!["lat"]?.float
                location.lng         = locationDict!["lng"]?.float
                
                let category = Category(entity: categoryEntity!, insertIntoManagedObjectContext: currentContext)
                
                let priceInfo = PriceInfo(entity: priceEntity!, insertIntoManagedObjectContext: currentContext)
                priceInfo.priceCategory = priceDict!["currency"]?.string
                
                let stats = Stats(entity: statsEntity!, insertIntoManagedObjectContext: currentContext)
                stats.checkinsCount = statsDict!["checkinsCount"]?.number
                stats.usersCount    = statsDict!["userCount"]?.number
                stats.tipCount      = statsDict!["tipCount"]?.number
                
                let shop = Shop(entity: shopEntity!, insertIntoManagedObjectContext: currentContext)
                shop.name         = shopName
                shop.phone        = shopPhone
                shop.specialCount = specialCount
                shop.location     = location
                shop.category     = category
                shop.priceInfo    = priceInfo
                shop.stats        = stats
            }
            
            coreDataStack.saveContext()
        }
        catch let error as NSError {
            print("Deserialization error: \(error.localizedDescription)")
        }
    }
}

