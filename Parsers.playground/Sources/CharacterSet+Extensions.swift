import Foundation

public extension CharacterSet {
    public func contains(_ character: Character) -> Bool {
        guard let value = character.unicodeScalars.first else { return false }
        return contains(value)
    }
}
