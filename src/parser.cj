package egg

import std.unicode.*
import std.convert.*
import std.regex.*
import std.collection.*

// 定义特殊字符枚举
enum SpecialChar {
    | Quote           // "
    | Hash            // #
    | LeftParen       // (
    | RightParen      // )
    | Minus           // -
    | Newline         // \n
    | Space           // 空格
    | Tab             // \t
    | CarriageReturn  // \r

    // 获取字符的 UInt8 值
    public func getValue(): UInt8 {
        match (this) {
            case Quote => 34
            case Hash => 35
            case LeftParen => 40
            case RightParen => 41
            case Minus => 45
            case Newline => 10
            case Space => 32
            case Tab => 9
            case CarriageReturn => 13
        }
    }

    // 检查给定字符是否匹配这个枚举值
    public func matches(c: UInt8): Bool {
        return c == getValue()
    }

    // 检查字符是否为空白字符
    public static func isWhitespace(c: UInt8): Bool {
        return Space.matches(c) || Tab.matches(c) || Newline.matches(c) || CarriageReturn.matches(c)
    }

    // 检查字符是否为有效的单词字符
    public static func isValidWordChar(c: UInt8): Bool {
        if (c.isAsciiLetter()) {
            return true
        }
        // 检查特殊字符
        let specialChars = "+-*/=<>!?"
        for (ch in specialChars) {
            if (c == UInt8(ch)) {
                return true
            }
        }
        return false
    }
}

class Parser {
    var input: String
    var pos: Int64

    public init(input: String) {
        this.input = input
        this.pos = 0
    }

    // 辅助函数跳过空格和注释
    func skipSpace(): Unit {
        while (pos < input.size) {
            let c: UInt8 = input[pos]
            // 跳过注释（以 # 开始）
            if (Hash.matches(c)) {
                // 跳过到换行符
                while (pos < input.size && !Newline.matches(input[pos])) {
                    pos++
                }
            } else if (SpecialChar.isWhitespace(c)) {
                pos += 1
            } else {
                break
            }
        }
    }

    public func parse(program: String): Expression {
        this.input = program
        this.pos = 0
        let res = parseExpression()
        skipSpace()
        if (pos < input.size) {
            throw ParseException("程序结束后出现意外文本 " + input[pos..input.size])
        }
        return res
    }

    func parseExpression(): Expression {
        skipSpace()
        if (pos >= input.size) {
            throw ParseException("输入意外结束，需要更多内容")
        }
        let c: UInt8 = input[pos]
        
        if (Quote.matches(c)) {
            return parseStringLiteral()
        } else if (c.isAsciiNumber() || (pos + 1 < input.size && Minus.matches(input[pos]) && input[pos + 1].isAsciiNumber())) {
            return parseNumberLiteral()
        } else if (SpecialChar.isValidWordChar(c)) {
            return parseWord()
        } else if (LeftParen.matches(c)) {
            return parseApply()
        } else {
            throw ParseException("无法解析的表达式" + c.toString())
        }
    }

    func parseStringLiteral(): ValueExpression {
        pos += 1
        let start = pos
        // 查找结束引号
        while (pos < input.size && !Quote.matches(input[pos])) {
            pos += 1
        }
        if (pos >= input.size) {
            throw ParseException("字符串没有结束")
        }
        let str: String = input[start..pos]
        pos += 1
        return ValueExpression(Value<String>(str))
    }

    func parseNumberLiteral(): Expression {
        let regex = Regex("^-?\\d+(\\.\\d+)?([eE][-+]?\\d+)?")
        let matcher = Matcher(regex, input[pos..input.size])
        let matchData = matcher.find().getOrThrow({=> ParseException("期望一个数字")})
        let str = matchData.matchStr()
        pos += str.size
        let num = Float64.parse(str)
        return ValueExpression(Value<Float64>(num))
    }

    func parseWord(): Expression {
        let regex = Regex("^[\\w+*/=<>!?-]+")
        let matcher = Matcher(regex, input[pos..input.size])
        let matchData = matcher.find().getOrThrow({=> ParseException("期望一个单词（标识符）")})
        let str = matchData.matchStr()
        pos += str.size
        if (str == "true") {
            return ValueExpression(Value<Bool>(true))
        } else if (str == "false") {
            return ValueExpression(Value<Bool>(false))
        } else {
            return WordExpression(str)
        }
    }

    func parseApply(): Expression {
        let c = input[pos]
        pos += 1
        skipSpace()
        let op = parseExpression()
        let args = ArrayList<Expression>()
        while (true) {
            skipSpace()
            if (pos >= input.size) {
                throw ParseException("应用表达式未闭合，期望 ')'")
            }
            if (RightParen.matches(input[pos])) {
                pos += 1
                break
            }
            let arg = parseExpression()
            args.append(arg)
        }
        return ApplyExpression(op, args.toArray())
    }
}

class ParseException <: Exception {
    public init(message: String) {
        super(message)
    }
}