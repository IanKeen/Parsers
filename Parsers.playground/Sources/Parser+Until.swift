public extension Parser {
    /// Use this `Parser` to take as much of the input as possible until `other` matches
    public func until(other: Parser?) -> Parser {
        guard let other = other else { return self }
        
        return GreedyParser(first: self, second: other)
    }
}

private struct GreedyParser: Parser {
    // MARK: - Private Properties
    private let first: Parser
    private let second: Parser
    
    // MARK: - Internal Properties
    var greedy: Bool { return first.greedy }

    // MARK: - Lifecycle
    init(first: Parser, second: Parser) {
        self.first = first
        self.second = second
    }
    
    // MARK: - Internal Functions
    func parse(input: Substring) -> Token? {
        switch (first.greedy, second.greedy) {
        case (false, _): // first one isn't greedy, just use it
            return first.parse(input: input)
            
        case (true, true): // both are greedy, let the first consume as much as it wants
            return first.parse(input: input)
            
        case (true, false): // only first is greedy, stop it as soon the second one matches
            for index in input.indices {
                // find the position `second` matches from
                guard second.parse(input: input[index...]) != nil else { continue }
                
                return first.parse(input: input[..<index])
            }
            
            // second never matched
            return first.parse(input: input)
        }
    }
}
