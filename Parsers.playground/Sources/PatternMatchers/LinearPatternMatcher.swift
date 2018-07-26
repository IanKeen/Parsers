import Foundation

/// Matches a sequence of `Parser`s from left to right
public class LinearPatternMatcher {
    public enum Option: Hashable {
        case lowerCaseInput
        case skipWhitespaceAndNewlines
    }
    
    // MARK: - Private Properties
    private let input: String
    private let pattern: [Parser]
    private let options: Set<Option>
    
    // MARK: - Lifecycle
    public init(input: String, pattern: [Parser], options: Set<Option> = [.lowerCaseInput, .skipWhitespaceAndNewlines]) {
        self.input = input
        self.pattern = pattern
        self.options = options
    }
    
    // MARK: - Public Functions
    public func parse() -> PatternMatch? {
        guard !pattern.isEmpty else { return nil }
        
        var input: Substring = Substring(self.input)
        if options.contains(.lowerCaseInput) {
            input = Substring(self.input.lowercased())
        }
        
        var tokens: [Token] = []
        tokens.reserveCapacity(pattern.count)
        
        var iterator = pattern.makeIterator()
        _ = iterator.next() // skip the first parser
        
        func fail() -> PatternMatch? {
            print("Pattern matching failed")
            if !input.isEmpty {
                print("- The input was not fully comsumed, remainder: '\(input)'")
            } else if tokens.count != pattern.count {
                print("- The parsers were not completely used, only the first \(tokens.count)")
            }
            print(tokens.isEmpty
                ? "- Nothing parsed"
                : "- Parsed up to: '\(self.input[tokens.first!.matched.startIndex...tokens.last!.matched.endIndex])'"
            )
            return nil
        }
        
        for parser in pattern {
            guard let token = parser.until(other: iterator.next()).parse(input: input)
                else { return fail() }
            
            tokens.append(token)
            input = input[token.matched.endIndex...]
            
            if options.contains(.skipWhitespaceAndNewlines) {
                input = input.drop(while: { CharacterSet.whitespacesAndNewlines.contains($0) })
            }
        }
        
        guard input.isEmpty else { return fail() }
        
        return PatternMatch(tokens: tokens)
    }
}
