import Foundation
import CoreData

@objc(SettingsEntity)
public class SettingsEntity: NSManagedObject {
    
    // MARK: - Convenience Initializers
    
    convenience init(context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.pomodoroWorkMinutes = 25
        self.pomodoroBreakMinutes = 5
        self.pomodoroLongBreakMinutes = 15
        self.enableNotifications = true
        self.enableSounds = true
        self.theme = "auto"
        self.lastModified = Date()
    }
    
    // MARK: - Computed Properties
    
    var themeMode: ThemeMode {
        get {
            return ThemeMode(rawValue: theme) ?? .auto
        }
        set {
            theme = newValue.rawValue
            lastModified = Date()
        }
    }
    
    var isQuietHoursActive: Bool {
        guard let start = quietHoursStart,
              let end = quietHoursEnd else { return false }
        
        let now = Date()
        let calendar = Calendar.current
        
        let startTime = calendar.dateComponents([.hour, .minute], from: start)
        let endTime = calendar.dateComponents([.hour, .minute], from: end)
        let currentTime = calendar.dateComponents([.hour, .minute], from: now)
        
        let startMinutes = (startTime.hour ?? 0) * 60 + (startTime.minute ?? 0)
        let endMinutes = (endTime.hour ?? 0) * 60 + (endTime.minute ?? 0)
        let currentMinutes = (currentTime.hour ?? 0) * 60 + (currentTime.minute ?? 0)
        
        if startMinutes <= endMinutes {
            // 同一天内的时间段
            return currentMinutes >= startMinutes && currentMinutes <= endMinutes
        } else {
            // 跨越午夜的时间段
            return currentMinutes >= startMinutes || currentMinutes <= endMinutes
        }
    }
    
    // MARK: - Methods
    
    func updateLastModified() {
        lastModified = Date()
    }
    
    // MARK: - Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validatePomodoroSettings()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePomodoroSettings()
    }
    
    private func validatePomodoroSettings() throws {
        if pomodoroWorkMinutes < 1 || pomodoroWorkMinutes > 60 {
            throw SettingsValidationError.invalidWorkMinutes
        }
        
        if pomodoroBreakMinutes < 1 || pomodoroBreakMinutes > 30 {
            throw SettingsValidationError.invalidBreakMinutes
        }
        
        if pomodoroLongBreakMinutes < 1 || pomodoroLongBreakMinutes > 60 {
            throw SettingsValidationError.invalidLongBreakMinutes
        }
    }
}

// MARK: - Theme Mode

enum ThemeMode: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    var displayName: String {
        switch self {
        case .light:
            return "浅色模式"
        case .dark:
            return "深色模式"
        case .auto:
            return "跟随系统"
        }
    }
}

// MARK: - Settings Validation Errors

enum SettingsValidationError: LocalizedError {
    case invalidWorkMinutes
    case invalidBreakMinutes
    case invalidLongBreakMinutes
    
    var errorDescription: String? {
        switch self {
        case .invalidWorkMinutes:
            return "工作时间必须在1-60分钟之间"
        case .invalidBreakMinutes:
            return "短休息时间必须在1-30分钟之间"
        case .invalidLongBreakMinutes:
            return "长休息时间必须在1-60分钟之间"
        }
    }
}