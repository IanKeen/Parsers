/// The result of a successful `Parser.parse(input:)`
public struct Token {
    /// The key associated with this `Token`.
    public let key: String?
    
    /// The portion of the overall `String` that this token represents.
    public let matched: Substring
    
    /// The typed value that represents this matched portion of the overall `String`.
    public let value: Any
}

public extension Token {
    public init(matched: Substring, value: Any) {
        self.key = nil
        self.matched = matched
        self.value = value
    }
}

public protocol Parser {
    /// When `true` the `Parser` could potentially consume all of the input
    var greedy: Bool { get }
    
    /// Attempts to parse a `Token` from the beginning of the input
    func parse(input: Substring) -> Token?
}

/// Internal concrete implementation
public struct _Parser: Parser {
    public let greedy: Bool
    let parse: (_ input: Substring) -> Token?
    
    public init(greedy: Bool, parse: @escaping (_ input: Substring) -> Token?) {
        self.greedy = greedy
        self.parse = parse
    }
    
    public func parse(input: Substring) -> Token? {
        return parse(input)
    }
}
