import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {
    
    // MARK: - Convenience Initializers
    
    convenience init(context: NSManagedObjectContext, title: String, category: TaskCategory, description: String? = nil, estimatedMinutes: Int32 = 0) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.category = category.rawValue
        self.taskDescription = description
        self.estimatedMinutes = estimatedMinutes
        self.createdAt = Date()
        self.lastModified = Date()
        self.isCompleted = false
        self.isRecurring = false
        self.priority = 0
        self.order = 0
    }
    
    // MARK: - Computed Properties
    
    var taskCategory: TaskCategory {
        get {
            return TaskCategory(rawValue: category) ?? .work
        }
        set {
            category = newValue.rawValue
            lastModified = Date()
        }
    }
    
    var isOverdue: Bool {
        guard let reminderTime = reminderTime else { return false }
        return !isCompleted && reminderTime < Date()
    }
    
    var tagsArray: [String] {
        get {
            guard let tags = tags, !tags.isEmpty else { return [] }
            return tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
        set {
            tags = newValue.joined(separator: ",")
            lastModified = Date()
        }
    }
    
    // MARK: - Methods
    
    func toggleCompletion() {
        isCompleted.toggle()
        completedAt = isCompleted ? Date() : nil
        lastModified = Date()
    }
    
    func updateLastModified() {
        lastModified = Date()
    }
    
    // MARK: - Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateTitle()
        try validateCategory()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateTitle()
        try validateCategory()
    }
    
    private func validateTitle() throws {
        guard let title = title, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyTitle
        }
        
        if title.count > 200 {
            throw ValidationError.titleTooLong
        }
    }
    
    private func validateCategory() throws {
        guard TaskCategory(rawValue: category) != nil else {
            throw ValidationError.invalidCategory
        }
    }
}

// MARK: - Validation Errors

enum ValidationError: LocalizedError {
    case emptyTitle
    case titleTooLong
    case invalidCategory
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "任务标题不能为空"
        case .titleTooLong:
            return "任务标题不能超过200个字符"
        case .invalidCategory:
            return "无效的任务类别"
        }
    }
}