import Foundation

enum Difficulty { case easy, hard }

class Settings {
    
    static let shared = Settings()
    
    var difficulty: Difficulty = .easy
}
