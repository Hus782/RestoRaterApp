//
//  Persistence.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RestoRaterApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func populateInitialDataIfNeeded() {
        let isPrePopulated = UserDefaults.standard.bool(forKey: "isPrePopulated")
        
        if !isPrePopulated {
            insertInitialData()
        }
    }
    
    func insertInitialData() {
        // Insert initial data here
        let context = container.viewContext
        
        let restaurant1 = Restaurant(context: context)
        restaurant1.name = "Restaurant 1"
        restaurant1.address = "123 Main St"
        restaurant1.image = "123 Main St"
        
        let restaurant2 = Restaurant(context: context)
        restaurant2.name = "Restaurant 2"
        restaurant2.address = "123 Main St"
        restaurant2.image = "123 Main St"
        
        let restaurant3 = Restaurant(context: context)
        restaurant3.name = "Restaurant 3"
        restaurant3.address = "123 Main St"
        restaurant3.image = "123 Main St"
        
        let user1 = User(context: context)
        user1.name = "User A"
        user1.password = "test"
        user1.email = "test"
        user1.isAdmin = false

        let user2 = User(context: context)
        user2.name = "Admin"
        user2.password = "admin"
        user2.email = "admin"
        user2.isAdmin = true

        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "isPrePopulated")

        } catch {
            print("Failed to save initial data: \(error)")
        }
    }
}
