import Foundation

/// Matches a sequence of `Parser`s in any order
public class RandomPatternMatcher {
    public enum Option: Hashable {
        case lowerCaseInput
    }
    
    // MARK: - Private Properties
    private let input: String
    private let parsers: [Parser]
    private let options: Set<Option>
    
    // MARK: - Lifecycle
    public init(input: String, parsers: [Parser], options: Set<Option> = [.lowerCaseInput]) {
        self.input = input
        self.parsers = parsers
        self.options = options
    }
    
    // MARK: - Public Functions
    public func parse() -> PatternMatch? {
        var input: Substring = Substring(self.input)
        if options.contains(.lowerCaseInput) {
            input = Substring(self.input.lowercased())
        }
        
        var tokens: [Token] = []
        
        while !input.isEmpty, let token = parsers.any.parse(input: input) {
            tokens.append(token)
            input = input[token.matched.endIndex...]
        }
        
        if input.isEmpty {
            return PatternMatch(tokens: tokens)
        } else {
            return nil
        }
    }
}
