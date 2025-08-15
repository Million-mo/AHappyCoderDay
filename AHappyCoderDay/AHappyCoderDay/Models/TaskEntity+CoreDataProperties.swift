import Foundation
import CoreData

extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "Task")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var taskDescription: String?
    @NSManaged public var category: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var completedAt: Date?
    @NSManaged public var lastModified: Date
    @NSManaged public var estimatedMinutes: Int32
    @NSManaged public var priority: Int16
    @NSManaged public var order: Int16
    @NSManaged public var reminderTime: Date?
    @NSManaged public var isRecurring: Bool
    @NSManaged public var recurringPattern: String?
    @NSManaged public var tags: String?

}

// MARK: - Identifiable

extension TaskEntity: Identifiable {

}

// MARK: - Fetch Requests

extension TaskEntity {
    
    static func fetchRequestForCategory(_ category: TaskCategory) -> NSFetchRequest<TaskEntity> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.order, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: false)
        ]
        return request
    }
    
    static func fetchRequestForCompleted(_ completed: Bool) -> NSFetchRequest<TaskEntity> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: completed))
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.completedAt, ascending: false),
            NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: false)
        ]
        return request
    }
    
    static func fetchRequestForToday() -> NSFetchRequest<TaskEntity> {
        let request = fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.priority, ascending: false),
            NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: true)
        ]
        return request
    }
    
    static func fetchRequestForOverdue() -> NSFetchRequest<TaskEntity> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == NO AND reminderTime != nil AND reminderTime < %@", Date() as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.reminderTime, ascending: true)
        ]
        return request
    }
}