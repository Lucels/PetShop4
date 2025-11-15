import Foundation

struct APIResponse: Codable {
    let count: Int
    let results: [Product]
}

struct Product: Identifiable, Equatable, Hashable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
    let category: String
    let rating: Double
    let stock: Int
}

