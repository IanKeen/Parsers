private let truthy = ["true", "t", "yes", "y", "1"].any
private let falsey = ["false", "f", "no", "n", "0"].any

public extension Bool {
    /// Parse as much of the input as possible trying to match an instance of the receiver
    public static var any: Parser {
        return _Parser(
            greedy: false,
            parse: { input in
                if let positive = truthy.parse(input: input) {
                    return Token(key: nil, matched: input[..<positive.matched.endIndex], value: true)
                } else if let negative = falsey.parse(input: input) {
                    return Token(key: nil, matched: input[..<negative.matched.endIndex], value: false)
                }
                
                return nil
            }
        )
    }
}
