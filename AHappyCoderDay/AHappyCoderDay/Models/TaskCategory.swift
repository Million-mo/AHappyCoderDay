import Foundation

enum TaskCategory: String, CaseIterable, Identifiable {
    case work = "工作篇"
    case health = "健康篇"
    case life = "生活篇"
    case mind = "心灵篇"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .work:
            return "laptopcomputer"
        case .health:
            return "heart.fill"
        case .life:
            return "house.fill"
        case .mind:
            return "brain.head.profile"
        }
    }
    
    var color: String {
        switch self {
        case .work:
            return "blue"
        case .health:
            return "red"
        case .life:
            return "green"
        case .mind:
            return "purple"
        }
    }
    
    var description: String {
        switch self {
        case .work:
            return "代码仪式感、工作节奏管理"
        case .health:
            return "颈椎操、喝水提醒、数字排毒"
        case .life:
            return "非数字成就感、社交优化"
        case .mind:
            return "程序员冥想、认知升级"
        }
    }
}