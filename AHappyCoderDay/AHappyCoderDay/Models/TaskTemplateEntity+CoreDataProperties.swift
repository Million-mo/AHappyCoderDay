import Foundation
import CoreData

extension TaskTemplateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskTemplateEntity> {
        return NSFetchRequest<TaskTemplateEntity>(entityName: "TaskTemplate")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var templateDescription: String?
    @NSManaged public var category: String
    @NSManaged public var isBuiltIn: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var lastModified: Date
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension TaskTemplateEntity {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: TaskTemplateItemEntity)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: TaskTemplateItemEntity)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: - Identifiable

extension TaskTemplateEntity: Identifiable {

}

// MARK: - Fetch Requests

extension TaskTemplateEntity {
    
    static func fetchRequestForCategory(_ category: TaskCategory) -> NSFetchRequest<TaskTemplateEntity> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskTemplateEntity.isBuiltIn, ascending: false),
            NSSortDescriptor(keyPath: \TaskTemplateEntity.name, ascending: true)
        ]
        return request
    }
    
    static func fetchRequestForBuiltIn() -> NSFetchRequest<TaskTemplateEntity> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "isBuiltIn == YES")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskTemplateEntity.category, ascending: true),
            NSSortDescriptor(keyPath: \TaskTemplateEntity.name, ascending: true)
        ]
        return request
    }
    
    static func fetchRequestForCustom() -> NSFetchRequest<TaskTemplateEntity> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "isBuiltIn == NO")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskTemplateEntity.category, ascending: true),
            NSSortDescriptor(keyPath: \TaskTemplateEntity.lastModified, ascending: false)
        ]
        return request
    }
}