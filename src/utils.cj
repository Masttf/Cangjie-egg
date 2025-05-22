package egg

class Value<T> <: Object {
    var value: T
    public init(value: T) {
        this.value = value
    }
}
class Utils {
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
        if(value is Value<String>) {
			let str = (value as Value<String>).getOrThrow({=> EvaluateException("字符串转换错误")})
			return "${str.value}"
		} else if(value is Value<Float64>) {
			let str = (value as Value<Float64>).getOrThrow({=> EvaluateException("字符串转换错误")})
			return "${str.value}"
		} else if(value is Value<Int64>) {
			let str = (value as Value<Int64>).getOrThrow({=> EvaluateException("字符串转换错误")})
			return "${str.value}"
		} else if(value is Value<Bool>) {
			let str = (value as Value<Bool>).getOrThrow({=> EvaluateException("字符串转换错误")})
			return "${str.value}"
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