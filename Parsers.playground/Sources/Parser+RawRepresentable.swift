/// Represents a parsable `RawRepresentable`
public protocol RawRepresentableParser: Parser, RawRepresentable where RawValue: Parser { }

extension RawRepresentableParser {
    public var greedy: Bool { return false }
    
    public func parse(input: Substring) -> Token? {
        return rawValue.parse(input: input)
    }
}

public extension RawRepresentableParser where RawValue: LosslessStringConvertible {
    /// Parses the input to try and match a `RawValue` to create an instance of the receiver
    public static var any: Parser {
        return _Parser(
            greedy: false,
            parse: { input in
                // TODO - a more efficient implementation using `CaseIterable`
                //        should be added when available with this as a fallback.
                //        `CaseIterable` would allow direct iteration of the cases
                //        to look for a value rather than potentially iterating the whole input
                var endIndex = input.startIndex
                var result: Self? = nil
                
                for index in input.indices {
                    endIndex = index
                    
                    guard
                        let rawValue = RawValue(String(input[...index])),
                        let value = self.init(rawValue: rawValue)
                        else { continue }
                    
                    result = value
                    break
                }
                
                guard let instance = result else { return nil }
                
                return Token(matched: input[...endIndex], value: instance)
            }
        )
    }
}
