package egg

class Value<T> <: Object {
    var value: T

    public init(value: T) {
        this.value = value
    }
}

class Utils {
    public static func ensureNumber(value: Object, operationName: String): Float64 {
        if (value is Value<Float64>) {
            let temp = (value as Value<Float64>).getOrThrow({=> Exception("操作符 ${operationName} 需要数字类型参数")})
            return temp.value
        } else if (value is Value<Int64>) {
            let temp = (value as Value<Int64>).getOrThrow({=> Exception("操作符 ${operationName} 需要数字类型参数")})
            return Float64(temp.value)
        } else {
            throw Exception("操作符 ${operationName} 需要数字类型参数")
        }
    }

    /**
     * 将 Egg 的内部值转换为适合打印的字符串表示。
     * @param value 要转换的值
     * @return 值的字符串表示
     */
    public static func convertObjectToString(value: Object): String {
        if (value is Value<String>) {
            let str = (value as Value<String>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else if (value is Value<Float64>) {
            let str = (value as Value<Float64>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else if (value is Value<Int64>) {
            let str = (value as Value<Int64>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else if (value is Value<Bool>) {
            let str = (value as Value<Bool>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else if (value is Value<Array<Object>>) {
            let array = (value as Value<Array<Object>>).getOrThrow({=> Exception("数组转换错误")})
            var str = "["
            for (i in 0..array.value.size) {
                str += convertObjectToString(array.value[i])
                if (i != array.value.size - 1) {
                    str += ", "
                }
            }
            str += "]"
            return str
        } else if (value is UserDefinedFunction) {
            return "UserDefinedFunction"
        } else if (value is EggFunction) {
            return "EggFunction"
        } else if (value is SpecialForm) {
            return "SpecialForm"
        } else if (value is Expression) {
            let expr = (value as Expression).getOrThrow({=> Exception("表达式转换错误")})
            return expr.toString()
        } else {
            return "unknown"
        }
    }

    // 跳过空格、制表符、换行符和回车符
    public static func isWhitespace(c: UInt8): Bool {
        return c == 32 || c == 9 || c == 10 || c == 13  // 空格、制表符、换行符、回车符
    }

    public static func isBank(value: String): Bool {
        if (value.isEmpty()) {
            return true
        }
        for (c in value) {
            if (Utils.isWhitespace(c) == false) {
                return false
            }
        }
        return true
    }
}