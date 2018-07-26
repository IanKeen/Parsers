import UIKit
import Foundation

// MARK: - Individual attribute parser
public struct AttributedStringParser: Parser {
    public enum Delimiters {
        case none, both
    }
    
    private let delimiters: Delimiters
    private let parser: Parser
    private let attributes: [NSAttributedStringKey: Any]
    
    public var greedy: Bool { return parser.greedy }
    
    public func parse(input: Substring) -> Token? {
        guard let token = parser.parse(input: input)
            else { return nil }
        
        let value: Substring
        switch delimiters {
        case .none: value = token.matched
        case .both: value = token.matched.dropFirst().dropLast()
        }
        
        return Token(
            matched: token.matched,
            value: NSAttributedString(
                string: String(value),
                attributes: attributes
            )
        )
    }
}

// MARK: - String > NSAttributedString pattern matcher
public struct AttributedStringPatternMatcher {
    // MARK: - Private Properties
    private let input: String
    private let parsers: [Parser]
    
    // MARK: - Lifecycle
    public init(input: String, parsers: [AttributedStringParser]) {
        self.input = input
        self.parsers = parsers
    }
    public func parse() -> NSAttributedString? {
        let randomMatcher = RandomPatternMatcher(input: input, parsers: parsers)
        guard let result = randomMatcher.parse() else { return nil }
        
        let output = NSMutableAttributedString(string: "")
        
        for token in result.tokens {
            guard let part = token.value as? NSAttributedString
                else { fatalError("Invalid parser, must return NSAttributedString value") }
            
            output.append(part)
        }
        
        return NSAttributedString(attributedString: output)
    }
}

// MARK: - Example attribute presets
public extension AttributedStringParser {
    public static var bold: AttributedStringParser {
        return AttributedStringParser(
            delimiters: .both,
            parser: ["[", String.any, "]"].all,
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor: UIColor.red
            ]
        )
    }
    public static var italic: AttributedStringParser {
        return AttributedStringParser(
            delimiters: .both,
            parser: ["_", String.any, "_"].all,
            attributes: [
                .font : UIFont.italicSystemFont(ofSize: 16),
                .foregroundColor: UIColor.blue
            ]
        )
    }
    public static var normal: AttributedStringParser {
        return AttributedStringParser(
            delimiters: .none,
            parser: String.any.until(other: ["[", "_"].any),
            attributes: [
                .font : UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.white
            ]
        )
    }
}

// MARK: - Example usage
let input = "testing [bold!!] _1_2[3]"
let parser = AttributedStringPatternMatcher(
    input: input,
    parsers: [.bold, .italic, .normal]
)
let result = parser.parse()
