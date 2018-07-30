public extension Parser {
    /// Make this `Parser` optional, allowing it to succeed even if no value could be matched.
    public var orNone: Parser {
        return _Parser(
            greedy: greedy,
            parse: { input in
                return self.parse(input: input) ?? Token(
                    key: nil,
                    matched: input[input.startIndex..<input.startIndex],
                    value: Optional<Self>.none as Any
                )
            }
        )
    }
}

public extension Parser {
    /// Inverts the `Parser` requiring that it _doesn't_ match
    public var not: Parser {
        return _Parser(
            greedy: greedy,
            parse: { input in
                guard self.parse(input: input) == nil else { return nil }
                
                return Token(
                    key: nil,
                    matched: input[input.startIndex..<input.startIndex],
                    value: Optional<Self>.none as Any
                )
            }
        )
    }
}

public prefix func !(parser: Parser) -> Parser {
    return parser.not
}
