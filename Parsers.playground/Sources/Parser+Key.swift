public extension Parser {
    /// Assign a key to the result of this `Parser` should it succeed.
    public func key(name: String) -> Parser {
        return _Parser(
            greedy: greedy,
            parse: { input in
                guard let token = self.parse(input: input) else { return nil }
                
                return Token(key: name, matched: token.matched, value: token.value)
            }
        )
    }
}
