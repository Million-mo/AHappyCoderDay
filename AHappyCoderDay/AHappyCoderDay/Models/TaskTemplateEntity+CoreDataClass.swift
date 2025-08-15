import Foundation
import CoreData

@objc(TaskTemplateEntity)
public class TaskTemplateEntity: NSManagedObject {
    
    // MARK: - Convenience Initializers
    
    convenience init(context: NSManagedObjectContext, name: String, category: TaskCategory, description: String? = nil, isBuiltIn: Bool = false) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.category = category.rawValue
        self.templateDescription = description
        self.isBuiltIn = isBuiltIn
        self.createdAt = Date()
        self.lastModified = Date()
    }
    
    // MARK: - Computed Properties
    
    var templateCategory: TaskCategory {
        get {
            return TaskCategory(rawValue: category) ?? .work
        }
        set {
            category = newValue.rawValue
            lastModified = Date()
        }
    }
    
    var itemsArray: [TaskTemplateItemEntity] {
        let set = items as? Set<TaskTemplateItemEntity> ?? []
        return set.sorted { $0.order < $1.order }
    }
    
    var totalEstimatedMinutes: Int32 {
        return itemsArray.reduce(0) { $0 + $1.estimatedMinutes }
    }
    
    var itemCount: Int {
        return itemsArray.count
    }
    
    // MARK: - Methods
    
    func addItem(title: String, description: String? = nil, estimatedMinutes: Int32 = 0, priority: Int16 = 0) {
        guard let context = managedObjectContext else { return }
        
        let item = TaskTemplateItemEntity(context: context, title: title, description: description, estimatedMinutes: estimatedMinutes, priority: priority)
        item.order = Int16(itemsArray.count)
        item.template = self
        
        lastModified = Date()
    }
    
    func removeItem(_ item: TaskTemplateItemEntity) {
        guard let context = managedObjectContext else { return }
        
        // 重新排序剩余项目
        let remainingItems = itemsArray.filter { $0 != item }
        for (index, remainingItem) in remainingItems.enumerated() {
            remainingItem.order = Int16(index)
        }
        
        context.delete(item)
        lastModified = Date()
    }
    
    func reorderItems(_ items: [TaskTemplateItemEntity]) {
        for (index, item) in items.enumerated() {
            item.order = Int16(index)
        }
        lastModified = Date()
    }
    
    func createTasks(in context: NSManagedObjectContext) -> [TaskEntity] {
        var createdTasks: [TaskEntity] = []
        
        for item in itemsArray {
            let task = TaskEntity(
                context: context,
                title: item.title,
                category: templateCategory,
                description: item.itemDescription,
                estimatedMinutes: item.estimatedMinutes
            )
            task.priority = item.priority
            createdTasks.append(task)
        }
        
        return createdTasks
    }
    
    func updateLastModified() {
        lastModified = Date()
    }
    
    // MARK: - Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateTemplate()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateTemplate()
    }
    
    private func validateTemplate() throws {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TemplateValidationError.emptyName
        }
        
        if name.count > 100 {
            throw TemplateValidationError.nameTooLong
        }
        
        guard TaskCategory(rawValue: category) != nil else {
            throw TemplateValidationError.invalidCategory
        }
    }
}

// MARK: - Template Validation Errors

enum TemplateValidationError: LocalizedError {
    case emptyName
    case nameTooLong
    case invalidCategory
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "模板名称不能为空"
        case .nameTooLong:
            return "模板名称不能超过100个字符"
        case .invalidCategory:
            return "无效的模板类别"
        }
    }
}