package egg
import std.unicode.*
import std.convert.*
import std.regex.*
import std.collection.*
class Parser {
    var input: String
    var pos: Int64

    Parser(input: String) {
        this.input = input
        this.pos = 0
    }
    func skipSpace() : Unit {
        while(pos < input.size) {
            let c: UInt8 = input[pos]
            if(c.toString() == "#"){
                while(pos < input.size && input[pos] != UInt8(10)) {
                    pos++
                }
            } else if(c == UInt8(9) || c == UInt8(10) || c == UInt8(13) || c == UInt8(32)) {
                pos += 1
            } else {
                break
            }
        }
    }
    func convertToObejct<T>(value: T) : Object {
        let res = (value as Object).getOrThrow({=> Exception("类型转换错误")})
        return res
    }

    func isValidWordChar(c: UInt8) : Bool {
        return c.isAsciiLetter() || "+-*/=<>!?-".contains(c.toString())
    }

    public func parse(program: String): Expression {
        this.input = program
        this.pos = 0
        let res = parseExpression()
        skipSpace()
        if(pos < input.size) {
            throw Exception("程序结束后出现意外文本 " + input[pos..input.size])
        }
        return res
        
    }

    func parseExpression(): Expression {
        skipSpace()
        if(pos >= input.size) {
            throw Exception("输入意外结束，需要更多内容")
        }
        let c: UInt8 = input[pos]
        // "
        if(c == UInt8(34)) {
            return parseStringLiteral()
        }else if(c.isAsciiNumber() || (pos + 1 < input.size && input[pos] == UInt8(45) && input[pos + 1].isAsciiNumber())) {
            return parseNumberLiteral()
        } else if(isValidWordChar(c)) {
            return parseWord()
        } else if(c == UInt8(40)) {
            return parseApply()
        } else {
            throw Exception("无法解析的表达式")
        }
    }
    func parseStringLiteral(): ValueExpression {
        pos += 1
        let start = pos
        while(pos < input.size && input[pos] != UInt8(34)) {
            pos += 1
        }
        if(pos >= input.size) {
            throw Exception("字符串没有结束")
        }
        let str: String = input[start..pos]
        pos += 1
        return ValueExpression(convertToObejct(str))
    }
    func parseNumberLiteral(): Expression {
        let regex = Regex("^-?\\d+(\\.\\d+)?([eE][-+]?\\d+)?")
        let matcher = Matcher(regex, input[pos..input.size])
        let matchData = matcher.find().getOrThrow({=> Exception("期望一个数字")})
        let str = matchData.matchStr()
        pos += str.size
        let num = Float64.parse(str)
        return ValueExpression(convertToObejct(num))
    }
    func parseWord(): Expression {
        let regex = Regex("^[\\w+*/=<>!?-]+")
        let matcher = Matcher(regex, input[pos..input.size])
        let matchData = matcher.find().getOrThrow({=> Exception("期望一个单词（标识符）")})
        let str = matchData.matchStr()
        pos += str.size
        if(str == "true") {
            return ValueExpression(convertToObejct(true))
        } else if(str == "false") {
            return ValueExpression(convertToObejct(false))
        } else{
            return ValueExpression(convertToObejct(str))
        }
    }
    func parseApply(): Expression {
        pos += 1
        skipSpace()
        let op = parseExpression()
        let args = ArrayList<Expression>()
        while(true) {
            skipSpace()
            if(pos >= input.size) {
                throw Exception("应用表达式未闭合期望')'")
            }
            if(input[pos] == UInt8(41)) {
                pos += 1
                break
            }
            let arg = parseExpression()
            args.append(arg)
        }
        return ApplyExpression(op, args.toArray())
    }

}