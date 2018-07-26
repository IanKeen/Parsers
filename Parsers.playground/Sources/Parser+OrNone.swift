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
