import Foundation
import CoreData

extension SettingsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsEntity> {
        return NSFetchRequest<SettingsEntity>(entityName: "Settings")
    }

    @NSManaged public var id: UUID
    @NSManaged public var pomodoroWorkMinutes: Int16
    @NSManaged public var pomodoroBreakMinutes: Int16
    @NSManaged public var pomodoroLongBreakMinutes: Int16
    @NSManaged public var enableNotifications: Bool
    @NSManaged public var enableSounds: Bool
    @NSManaged public var quietHoursStart: Date?
    @NSManaged public var quietHoursEnd: Date?
    @NSManaged public var theme: String
    @NSManaged public var lastModified: Date

}

// MARK: - Identifiable

extension SettingsEntity: Identifiable {

}

// MARK: - Singleton Access

extension SettingsEntity {
    
    static func fetchOrCreate(in context: NSManagedObjectContext) -> SettingsEntity {
        let request = fetchRequest()
        request.fetchLimit = 1
        
        do {
            let settings = try context.fetch(request)
            if let existingSettings = settings.first {
                return existingSettings
            }
        } catch {
            print("Error fetching settings: \(error)")
        }
        
        // 创建新的设置实例
        return SettingsEntity(context: context)
    }
}