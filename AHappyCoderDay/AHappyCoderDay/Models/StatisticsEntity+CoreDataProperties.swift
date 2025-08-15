import Foundation
import CoreData

extension StatisticsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatisticsEntity> {
        return NSFetchRequest<StatisticsEntity>(entityName: "Statistics")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var category: String
    @NSManaged public var totalTasks: Int16
    @NSManaged public var completedTasks: Int16
    @NSManaged public var pomodoroSessions: Int16
    @NSManaged public var focusTimeMinutes: Int32
    @NSManaged public var streakDays: Int16
    @NSManaged public var lastModified: Date

}

// MARK: - Identifiable

extension StatisticsEntity: Identifiable {

}

// MARK: - Fetch Requests

extension StatisticsEntity {
    
    static func fetchRequestForDate(_ date: Date) -> NSFetchRequest<StatisticsEntity> {
        let request = fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        request.predicate = NSPredicate(format: "date == %@", startOfDay as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \StatisticsEntity.category, ascending: true)
        ]
        return request
    }
    
    static func fetchRequestForCategory(_ category: TaskCategory) -> NSFetchRequest<StatisticsEntity> {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \StatisticsEntity.date, ascending: false)
        ]
        return request
    }
    
    static func fetchRequestForDateRange(from startDate: Date, to endDate: Date) -> NSFetchRequest<StatisticsEntity> {
        let request = fetchRequest()
        let startOfStartDate = Calendar.current.startOfDay(for: startDate)
        let endOfEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: endDate))!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfStartDate as NSDate, endOfEndDate as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \StatisticsEntity.date, ascending: true),
            NSSortDescriptor(keyPath: \StatisticsEntity.category, ascending: true)
        ]
        return request
    }
    
    static func fetchRequestForThisWeek() -> NSFetchRequest<StatisticsEntity> {
        let request = fetchRequest()
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.end ?? now
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfWeek as NSDate, endOfWeek as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \StatisticsEntity.date, ascending: true),
            NSSortDescriptor(keyPath: \StatisticsEntity.category, ascending: true)
        ]
        return request
    }
    
    static func fetchRequestForThisMonth() -> NSFetchRequest<StatisticsEntity> {
        let request = fetchRequest()
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfMonth as NSDate, endOfMonth as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \StatisticsEntity.date, ascending: true),
            NSSortDescriptor(keyPath: \StatisticsEntity.category, ascending: true)
        ]
        return request
    }
    
    static func fetchOrCreate(for date: Date, category: TaskCategory, in context: NSManagedObjectContext) -> StatisticsEntity {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "date == %@ AND category == %@", startOfDay as NSDate, category.rawValue)
        request.fetchLimit = 1
        
        do {
            let statistics = try context.fetch(request)
            if let existingStatistics = statistics.first {
                return existingStatistics
            }
        } catch {
            print("Error fetching statistics: \(error)")
        }
        
        // 创建新的统计实例
        return StatisticsEntity(context: context, date: date, category: category)
    }
}