import Foundation

class BadgesCalculator {
    
    static func computeBadges(from tickets: [Ticket]) -> [Badge] {
        // Только оплаченные и использованные билеты
        let validTickets = tickets.filter {
            $0.paymentStatus.lowercased() == "paid" && $0.used
        }
        
        let totalCount = validTickets.count
        
        // Группировка по категориям событий
        let categoryCounts = Dictionary(grouping: validTickets) { ticket in
            ticket.event.category.lowercased() ?? "general"
        }
        
        // Все возможные достижения
        var badges: [Badge] = []
        
        // 🥇 Общие достижения по количеству событий
        badges.append(contentsOf: [
            Badge(id: "first-event", title: "Первый визит",
                  description: "Посетил первое событие", icon: "🎉",
                  category: "general", requiredCount: 1,
                  currentCount: min(1, totalCount)),
            
            Badge(id: "event-fan", title: "Фанат событий",
                  description: "Посетил 5 событий", icon: "🔥",
                  category: "general", requiredCount: 5,
                  currentCount: totalCount),
            
            Badge(id: "event-master", title: "Мастер событий",
                  description: "Посетил 10 событий", icon: "🏆",
                  category: "general", requiredCount: 10,
                  currentCount: totalCount),
        ])
        
        // 🏷️ Достижения по категориям
        for (category, count) in categoryCounts {
            let categoryBadges = [
                Badge(id: "\(category)-fan", title: "\(category.capitalized) Fan",
                      description: "Посетил 3 \(category) события", icon: "❤️",
                      category: category, requiredCount: 3, currentCount: count),
                
                Badge(id: "\(category)-pro", title: "\(category.capitalized) Pro",
                      description: "Посетил 5 \(category) событий", icon: "⭐",
                      category: category, requiredCount: 5, currentCount: count)
            ]
            badges.append(contentsOf: categoryBadges)
        }
        
        // Сортировка: разблокированные сверху
        return badges.sorted { badge1, badge2 in
            if badge1.isUnlocked != badge2.isUnlocked {
                return badge1.isUnlocked
            }
            return badge1.progress > badge2.progress
        }
    }
}
