import Foundation
import UIKit

// Mock Event
let mockEvents: [Event] = [
    Event(
        id: 1,
        name: "LeetCode Workshop Series 💻🚀",
        description: "Join our hands-on workshop to master Python3 🐍, solve algorithmic challenges 🧠, and prepare for MAANG interviews.",
        location: "Online",
        date: "2025-12-23T09:00:00Z",
        organizer: "KBTU Coding Club",
        price: "0.00",
        isFree: true,
        category: "Семинары",
        ticketsAvailable: 49,
        mediaUrls: ["https://example.com/workshop.jpg"]  // замени на реальную картинку или оставь nil
    ),
    Event(
        id: 2,
        name: "Muertos Night Party 💀🎉",
        description: "Тематическая вечеринка в стиле Day of the Dead! Костюмы, музыка, танцы.",
        location: "KBTU Main Hall",
        date: "2025-10-31T20:00:00Z",
        organizer: "Student Life Committee",
        price: "5000",
        isFree: false,
        category: "Parties",
        ticketsAvailable: 0,
        mediaUrls: nil
    ),
    Event(
        id: 3,
        name: "Ярмарка клубов 2025",
        description: "Знакомство с клубами KBTU, игры, призы, выступления.",
        location: "Central Atrium",
        date: "2025-09-15T12:00:00Z",
        organizer: "Student Council",
        price: "0.00",
        isFree: true,
        category: "Ярмарки",
        ticketsAvailable: 200,
        mediaUrls: nil
    )
]

// Mock News
let mockNews: [NewsItem] = [
    NewsItem(
        id: 1,
        title: "Новый LeetCode Workshop уже скоро!",
        content: "Присоединяйтесь к серии воркшопов по алгоритмам и подготовке к интервью в MAANG компании. Бесплатно для всех студентов KBTU!",
        imageUrl: "https://example.com/leetcode.jpg",
        createdAt: "2025-12-10T08:49:49Z"
    ),
    NewsItem(
        id: 2,
        title: "Muertos Night — регистрация открыта",
        content: "Готовьте костюмы! Самая атмосферная вечеринка года уже близко.",
        imageUrl: nil,
        createdAt: "2025-12-05T14:20:00Z"
    )
]

// Mock Tickets (с разными статусами)
let mockTickets: [Ticket] = [
    Ticket(
        id: 1,
        userEmail: "y_yessenuly@kbtu.kz",
        event: mockEvents[0],
        qrcode: "00cecbe6-25a9-48a2-8557-3b527d98f413",
        paymentStatus: "paid",
        used: false,
        createdAt: "2025-12-12T09:26:58Z"
    ),
    Ticket(
        id: 2,
        userEmail: "y_yessenuly@kbtu.kz",
        event: mockEvents[1],
        qrcode: "1f83b721-4c7c-448e-a1b8-87e9cbec9744",
        paymentStatus: "pending",
        used: false,
        createdAt: "2025-12-12T10:30:00Z"
    ),
    Ticket(
        id: 3,
        userEmail: "y_yessenuly@kbtu.kz",
        event: mockEvents[2],
        qrcode: "bb829422-9f58-4614-8934-b4d685ec8bf8",
        paymentStatus: "unpaid",
        used: false,
        createdAt: "2025-12-13T12:00:00Z"
    )
]
