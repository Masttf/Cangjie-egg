package egg

class Utils {
    public static func convertToObejct<T>(value: T) : Object {
        let res = (value as Object).getOrThrow({=> Exception("类型转换错误")})
        return res
    }
    public static func ensureNumber(value: Object, operationName: String):Float64 {
        if(value is Float64) {
            return (value as Float64).getOrThrow({=> Exception("操作符 ${operationName} 需要数字类型参数")})
        } else if(value is Int) {
            return Float64((value as Int).getOrThrow({=> Exception("操作符 ${operationName} 需要数字类型参数")}))
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
        if(value is String) {
            return (value as String).getOrThrow({=> Exception("字符串转换错误")})
        } else if(value is Float64) {
            return "${(value as Float64).getOrThrow({=> Exception("字符串转换错误")})}"
        } else if(value is Int64) {
            return "${(value as Int64).getOrThrow({=> Exception("字符串转换错误")})}"
        } else if(value is Bool) {
            return "${(value as Bool).getOrThrow({=> Exception("字符串转换错误")})}"
        } else if(value is UserDefinedFunction){
            return "UserDefinedFunction"
        } else if(value is EggFunction){
            return "EggFunction"
        } else if(value is SpecialForm){
            return "SpecialForm"
        } else if(value is Expression){
            let expr = (value as Expression).getOrThrow({=> Exception("表达式转换错误")})
            return expr.toString()
        } else{
            return "unknown"
        }
    }
}