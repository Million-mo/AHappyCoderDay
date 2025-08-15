import Foundation
import CoreData

@objc(StatisticsEntity)
public class StatisticsEntity: NSManagedObject {
    
    // MARK: - Convenience Initializers
    
    convenience init(context: NSManagedObjectContext, date: Date, category: TaskCategory) {
        self.init(context: context)
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.category = category.rawValue
        self.totalTasks = 0
        self.completedTasks = 0
        self.pomodoroSessions = 0
        self.focusTimeMinutes = 0
        self.streakDays = 0
        self.lastModified = Date()
    }
    
    // MARK: - Computed Properties
    
    var statisticsCategory: TaskCategory {
        get {
            return TaskCategory(rawValue: category) ?? .work
        }
        set {
            category = newValue.rawValue
            lastModified = Date()
        }
    }
    
    var completionRate: Double {
        guard totalTasks > 0 else { return 0.0 }
        return Double(completedTasks) / Double(totalTasks)
    }
    
    var averageFocusTimePerTask: Double {
        guard completedTasks > 0 else { return 0.0 }
        return Double(focusTimeMinutes) / Double(completedTasks)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var isThisWeek: Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    var isThisMonth: Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
    }
    
    // MARK: - Methods
    
    func incrementCompletedTasks() {
        completedTasks += 1
        lastModified = Date()
    }
    
    func incrementTotalTasks() {
        totalTasks += 1
        lastModified = Date()
    }
    
    func addPomodoroSession(minutes: Int32) {
        pomodoroSessions += 1
        focusTimeMinutes += minutes
        lastModified = Date()
    }
    
    func updateStreak(_ days: Int16) {
        streakDays = days
        lastModified = Date()
    }
    
    func updateLastModified() {
        lastModified = Date()
    }
    
    // MARK: - Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateStatistics()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateStatistics()
    }
    
    private func validateStatistics() throws {
        if completedTasks < 0 {
            throw StatisticsValidationError.negativeCompletedTasks
        }
        
        if totalTasks < 0 {
            throw StatisticsValidationError.negativeTotalTasks
        }
        
        if completedTasks > totalTasks {
            throw StatisticsValidationError.completedExceedsTotal
        }
        
        if pomodoroSessions < 0 {
            throw StatisticsValidationError.negativePomodoroSessions
        }
        
        if focusTimeMinutes < 0 {
            throw StatisticsValidationError.negativeFocusTime
        }
    }
}

// MARK: - Statistics Validation Errors

enum StatisticsValidationError: LocalizedError {
    case negativeCompletedTasks
    case negativeTotalTasks
    case completedExceedsTotal
    case negativePomodoroSessions
    case negativeFocusTime
    
    var errorDescription: String? {
        switch self {
        case .negativeCompletedTasks:
            return "已完成任务数不能为负数"
        case .negativeTotalTasks:
            return "总任务数不能为负数"
        case .completedExceedsTotal:
            return "已完成任务数不能超过总任务数"
        case .negativePomodoroSessions:
            return "番茄工作法会话数不能为负数"
        case .negativeFocusTime:
            return "专注时间不能为负数"
        }
    }
}