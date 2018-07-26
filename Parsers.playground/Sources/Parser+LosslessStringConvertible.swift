import Foundation

/// Provides a default parsing implementation for any type that can be represented as a string in a lossless, unambiguous way.
public extension LosslessStringConvertible where Self: Parser {
    public var greedy: Bool { return false }
    
    public func parse(input: Substring) -> Token? {
        let string = description
        
        var inputIterator = input.indices.lazy.map({ ($0, input[$0]) }).makeIterator()
        var matchIndex: String.Index? = nil
        
        for character in string {
            guard
                let (index, inputCharacter) = inputIterator.next(),
                character == inputCharacter
                else { return nil }
            
            matchIndex = index
        }
        
        guard let index = matchIndex else { return nil }
        
        return Token(
            key: nil,
            matched: input[...index],
            value: self
        )
    }
}

/// Provides a default parsing implementation for any type that can be represented as a string in a lossless, unambiguous way.
public extension LosslessStringConvertible where Self: Parser {
    /// Parse as much of the input as possible trying to match an instance of the receiver
    public static var any: Parser {
        return _Parser(
            greedy: true,
            parse: { input in
                var endIndex = input.startIndex
                var result: Self? = nil
                
                for index in input.indices {
                    guard let value = self.init(String(input[...index])) else { break }
                    result = value
                    endIndex = index
                }
                
                guard let instance = result else { return nil }
                
                return Token(matched: input[...endIndex], value: instance)
            }
        )
    }
}

// MARK: - Conformance
extension String: Parser { }
extension Character: Parser { }
extension Int: Parser { }
extension Float: Parser { }
extension Double: Parser { }
extension Bool: Parser { }
