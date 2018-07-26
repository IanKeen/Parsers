import Foundation

public extension String {
    /// Parse as much of the input as possible trying to match an instance of the receiver
    public static var any: Parser {
        return _Parser(
            greedy: true,
            parse: { input in
                return Token(key: nil, matched: input, value: String(input))
            }
        )
    }
    
    /// A `Parser` that will match either the upper OR lower case representation of this value
    public var ignoringCase: Parser {
        return [uppercased(), lowercased()].any
    }
}

public extension String {
    /// Parse the input using the provided regular expression
    /// - Note: Matched value must be from the start of the input
    public static func matching(regex: String) -> Parser {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            
            return _Parser(
                greedy: false,
                parse: { input in
                    let string = String(input)
                    
                    guard
                        let match = regex.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string)),
                        match.range.location == 0
                        else { return nil }
                    
                    let endIndex = input.index(input.startIndex, offsetBy: match.range.length)
                    
                    return Token(
                        matched: input[...endIndex],
                        value: String(input[...endIndex])
                    )
                }
            )
            
        } catch let error {
            fatalError("Regex Error: \(error)")
        }
    }
}
