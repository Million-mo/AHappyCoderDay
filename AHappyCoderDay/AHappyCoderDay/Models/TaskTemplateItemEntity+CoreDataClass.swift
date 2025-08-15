import Foundation
import CoreData

@objc(TaskTemplateItemEntity)
public class TaskTemplateItemEntity: NSManagedObject {
    
    // MARK: - Convenience Initializers
    
    convenience init(context: NSManagedObjectContext, title: String, description: String? = nil, estimatedMinutes: Int32 = 0, priority: Int16 = 0) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.itemDescription = description
        self.estimatedMinutes = estimatedMinutes
        self.priority = priority
        self.order = 0
    }
    
    // MARK: - Methods
    
    func createTask(in context: NSManagedObjectContext, category: TaskCategory) -> TaskEntity {
        return TaskEntity(
            context: context,
            title: title,
            category: category,
            description: itemDescription,
            estimatedMinutes: estimatedMinutes
        )
    }
    
    // MARK: - Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateItem()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateItem()
    }
    
    private func validateItem() throws {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TemplateItemValidationError.emptyTitle
        }
        
        if title.count > 200 {
            throw TemplateItemValidationError.titleTooLong
        }
        
        if estimatedMinutes < 0 {
            throw TemplateItemValidationError.negativeEstimatedMinutes
        }
        
        if priority < 0 || priority > 5 {
            throw TemplateItemValidationError.invalidPriority
        }
    }
}

// MARK: - Template Item Validation Errors

enum TemplateItemValidationError: LocalizedError {
    case emptyTitle
    case titleTooLong
    case negativeEstimatedMinutes
    case invalidPriority
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "模板项标题不能为空"
        case .titleTooLong:
            return "模板项标题不能超过200个字符"
        case .negativeEstimatedMinutes:
            return "预估时间不能为负数"
        case .invalidPriority:
            return "优先级必须在0-5之间"
        }
    }
}