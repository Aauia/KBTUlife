import Foundation
struct Badge {
    let id: String
    let title: String
    let description: String
    let icon: String      // e.g. "🥇"
    let category: String  // "general", "sports", "tech"
    let requiredCount: Int
    let currentCount: Int

    var progress: Double {
        guard requiredCount > 0 else { return 1 }
        return min(1, Double(currentCount) / Double(requiredCount))
    }

    var isUnlocked: Bool {
        currentCount >= requiredCount
    }
}
