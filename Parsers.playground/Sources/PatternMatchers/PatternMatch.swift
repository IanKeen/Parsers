import Foundation

/// The result of a successful pattern matching operation
public struct PatternMatch {
    public enum Error: Swift.Error {
        case valueNotFound(key: String)
        case typeMismatch(key: String, expected: Any.Type, got: Any.Type)
    }
    
    /// The `Token`s that were matched
    public let tokens: [Token]
    
    /// Returns the underlying value for the `Token` with the provided key
    ///
    /// - Parameter key: The key of the `Token`
    /// - Returns: The typed value of the `Token`
    /// - Throws: `typeMismatch` if the value of the `Token` isn't the expected type
    public func value<T>(for key: String) throws -> T {
        guard let token = tokens.first(where: { $0.key == key }) else {
            throw Error.valueNotFound(key: key)
        }
        guard let value = token.value as? T else {
            throw Error.typeMismatch(key: key, expected: T.self, got: type(of: token.value))
        }
        return value
    }
}
