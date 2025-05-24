package egg
interface EggFunction {
  	func apply(args: Array<Object>): Object; 
}

/**
 * 代表由 'fun' 特殊形式创建的用户定义函数。
 * 实现了 EggFunction 接口，可以被调用。
 * 关键在于它存储了定义时的环境，形成了闭包。
 */
class UserDefinedFunction <:EggFunction {
    let params: Array<String>
    let body: Expression
    let env: Env
    public init(params: Array<String>, body: Expression, env: Env) {
        this.params = params
        this.body = body
        this.env = env
    }
    public override func apply(args: Array<Object>): Object {
        if(args.size != this.params.size) {
            throw Exception("函数调用错误：期望 ${this.params.size} 个参数，但实际传入 ${args.size} 个参数")
        }
        let localEnv = Env(this.env)
        for(i in 0..this.params.size) {
            let name = this.params[i]
            let value = args[i]
            localEnv.define(name, value)
        }
        return this.body.evaluate(localEnv)
    }
}

class add <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        var sum: Float64 = 0.0
        for(arg in args) {
            sum += Utils.ensureNumber(arg, "+")
        }
        return Value<Float64>(sum)
    }
}

class sub <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size == 0){
            throw Exception("操作符 '-' 需要至少一个参数")
        }
        var sum: Float64 = Utils.ensureNumber(args[0], "-")
        for(i in 1..args.size) {
            sum -= Utils.ensureNumber(args[i], "-")
        }
        return Value<Float64>(sum)
    }
}

class mul <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        var sum: Float64 = 1.0
        for(arg in args) {
            sum *= Utils.ensureNumber(arg, "*")
        }
        return Value<Float64>(sum)
    }
}
class div <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size != 2){
            throw Exception("操作符 '/' 需要两个参数")
        }
        var dividend: Float64 = Utils.ensureNumber(args[0], "/")
        var divisor: Float64 = Utils.ensureNumber(args[1], "/")
        if(divisor == 0.0) {
            throw Exception("除数不能为零")
        }
        var sum: Float64 = dividend / divisor
        return Value<Float64>(sum)
    }
}

class greater <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size != 2){
            throw Exception("操作符 '>' 需要两个参数")
        }
        var flag = Utils.ensureNumber(args[0], ">") > Utils.ensureNumber(args[1], ">")
        return Value<Bool>(flag)
    }
}

class less <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size != 2){
            throw Exception("操作符 '<' 需要两个参数")
        }
        var flag = Utils.ensureNumber(args[0], "<") < Utils.ensureNumber(args[1], "<")
        return Value<Bool>(flag)
    }
}

class equal <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size != 2){
            throw Exception("操作符 '==' 需要两个参数")
        }
        // 因为全程计算使用float64， 所以这里的比较其实应该加eps
        let val1 = Utils.ensureNumber(args[0], "==")
        let val2 = Utils.ensureNumber(args[1], "==")
        return Value<Bool>(val1 == val2)
    }
}

class printf <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size == 0){
            throw Exception("操作符 'printf' 需要至少一个参数")
        }
        var str = ""
        for(arg in args) {
            str += Utils.convertObjectToString(arg)
            str += " "
        }
        println(str)
        // Egg 的 print 函数按照约定返回 false
        return Value<Bool>(false)
    }
}

class array <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        return Value<Array<Object>>(args)
    }
}

class length <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size != 1){
            throw Exception("操作符 'length' 需要一个参数")
        }
        let array = args[0]
        if(array is Value<Array<Object>>) {
            let arr = (array as Value<Array<Object>>).getOrThrow({=> Exception("操作符 'length' 需要一个数组参数")})
            return Value<Float64>(Float64(arr.value.size))
        } else if(array is Value<String>) {
            let str = (array as Value<String>).getOrThrow({=> Exception("操作符 'length' 需要一个字符串参数")})
            return Value<Float64>(Float64(str.value.size))
        } else {
            throw Exception("操作符 'length' 需要一个数组或者字符串参数")
        }
    }
}

class element <: EggFunction {
    public override func apply(args: Array<Object>): Object {
        if(args.size != 2){
            throw Exception("操作符 'element' 需要两个参数")
        }
        let array = args[0]
        let index = args[1]
        if(array is Value<Array<Object>>) {
            let arr = (array as Value<Array<Object>>).getOrThrow({=> Exception("操作符 'element' 需要一个数组参数")})
            let floadt_idx = Utils.ensureNumber(index, "element")
            let idx = Int64(floadt_idx)
            if(idx < 0 || idx >= arr.value.size) {
                throw Exception("数组下标越界")
            }
            return arr.value[idx]
        } else if(array is Value<String>) {
            let str = (array as Value<String>).getOrThrow({=> Exception("操作符 'element' 需要一个字符串参数")})
            let floadt_idx = Utils.ensureNumber(index, "element")
            let idx = Int64(floadt_idx)
            if(idx < 0 || idx >= str.value.size) {
                throw Exception("字符串下标越界")
            }
            return Value<String>(String(Rune(str.value[idx])))
        }else {
            throw Exception("操作符 'element' 需要一个数组或者字符串参数")
        }
    }
}

class TopLevel{
    public static func create() : Env {
        let env = Env()
        env.define("true", Value<Bool>(true))
        env.define("false", Value<Bool>(false))

        env.define("if", IfSpacialForm())
        env.define("while", WhileSpacialForm())
        env.define("do", DoSpacialForm())
        env.define("define", DefineSpacialForm())
        env.define("fun", FunSpacialForm())

        env.define("+", add())
        env.define("-", sub())
        env.define("*", mul())
        env.define("/", div())
        env.define(">", greater())
        env.define("<", less())
        env.define("==", equal())


        env.define("printf", printf())
        env.define("array", array())
        env.define("length", length())
        env.define("element", element())
        return env
    }
}