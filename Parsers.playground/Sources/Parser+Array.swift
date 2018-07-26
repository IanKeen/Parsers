public extension Array where Element == Parser {
    /// Consolidates all `Parser`s together, returning the result of the first one that succeeds, if any
    public var any: Parser {
        return _Parser(
            greedy: contains(where: { $0.greedy }),
            parse: { input in
                return self.lazy.compactMap({ $0.parse(input: input) }).first
            }
        )
    }
}

extension Array where Element == Parser {
    /// Consolidates all `Parser`s together, requiring they all match to succeed
    public var all: Parser {
        return _Parser(
            greedy: contains(where: { $0.greedy }),
            parse: { input in
                guard !self.isEmpty else { return nil }
                
                var index = input.startIndex
                
                // create an iterator starting at the 'next' parser
                // so we can 'look ahead' and know when to stop
                var iterator = self.makeIterator()
                _ = iterator.next() // skip the first parser
                
                for parser in self {
                    guard let token = parser.until(other: iterator.next()).parse(input: input[index...])
                        else { return nil }
                    
                    index = token.matched.endIndex
                }
                
                return Token(
                    key: nil,
                    matched: input[..<index],
                    value: self
                )
            }
        )
    }
}
