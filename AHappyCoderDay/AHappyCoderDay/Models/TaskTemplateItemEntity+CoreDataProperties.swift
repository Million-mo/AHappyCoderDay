import Foundation
import CoreData

extension TaskTemplateItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskTemplateItemEntity> {
        return NSFetchRequest<TaskTemplateItemEntity>(entityName: "TaskTemplateItem")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var itemDescription: String?
    @NSManaged public var estimatedMinutes: Int32
    @NSManaged public var priority: Int16
    @NSManaged public var order: Int16
    @NSManaged public var template: TaskTemplateEntity?

}

// MARK: - Identifiable

extension TaskTemplateItemEntity: Identifiable {

}