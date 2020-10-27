//
//  DataController.swift
//  MyPortfolio
//
//  Created by Graham Reynolds on 25/10/20.
//

import CoreData
import SwiftUI


class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MyPortfolio")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            // set up items for each project
            for j in 1...Int.random(in: 2...10) {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.project = project
                item.priority = Int16.random(in: 1...3)
                item.completed = Bool.random()
            }
        }
        try viewContext.save()
    }
}



extension DataController {
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let req1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteReq1 = NSBatchDeleteRequest(fetchRequest: req1)
        _ = try? container.viewContext.execute(batchDeleteReq1)
        
        let req2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteReq2 = NSBatchDeleteRequest(fetchRequest: req2)
        _ = try? container.viewContext.execute(batchDeleteReq2)
    }
    
    
    func clearData() {
        let mom = container.managedObjectModel
        let moc = container.viewContext
        moc.performAndWait {
            for entity in mom.entities {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                do {
                    try moc.execute(batchDeleteRequest)
                } catch {
                    let nserror = error as NSError
                    fatalError("\(#function): failed to execute delete request,\n\(nserror.localizedDescription)")
                }
            }
        }
        try? moc.save()
        self.objectWillChange.send()
    }

}
