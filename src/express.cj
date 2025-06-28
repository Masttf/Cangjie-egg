package egg

interface Expression {
    func evaluate(env: Env): Object
    func toString(): String
}

// 值表达式
class ValueExpression <: Expression {
    var value: Object

    public init(value: Object) {
        this.value = value
    }

    public override func evaluate(env: Env): Object {
        return this.value
    }

    public override func toString(): String {
        if (this.value is Value<String>) {
            let str = (this.value as Value<String>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else if (this.value is Value<Float64>) {
            let str = (this.value as Value<Float64>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else if (this.value is Value<Int64>) {
            let str = (this.value as Value<Int64>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else if (this.value is Value<Bool>) {
            let str = (this.value as Value<Bool>).getOrThrow({=> EvaluateException("字符串转换错误")})
            return "${str.value}"
        } else {
            return "unknown"
        }
    }
}

// 标识符表达式
class WordExpression <: Expression {
    var name: String

    public init(name: String) {
        this.name = name
    }

    public override func evaluate(env: Env): Object {
        let value = env.get(this.name)
        return value.getOrThrow({=> EvaluateException("未定义的变量: ${this.name}")})
    }

    public override func toString(): String {
        return this.name
    }
}

// 应用表达式
class ApplyExpression <: Expression {
    var op: Expression
    var args: Array<Expression>

    public init(op: Expression, args: Array<Expression>) {
        this.op = op
        this.args = args
    }

    func getArgList(args: Array<Expression>, env: Env): Array<Object> {
        let argList = Array<Object>(args.size, item: Object())
        for (i in 0..args.size) {
            let arg = args[i]
            let value = arg.evaluate(env)
            argList[i] = value
        }
        return argList
    }

    public override func evaluate(env: Env): Object {
        let opValue: Object = this.op.evaluate(env)

        if (opValue is SpecialForm) {
            let spcialOp = (opValue as SpecialForm).getOrThrow({=> EvaluateException("操作符不是一个特殊形式")})
            return spcialOp.apply(this.args, env)
        } else if (opValue is EggFunction) {
            let argList = getArgList(this.args, env)
            let eggOp = (opValue as EggFunction).getOrThrow({=> EvaluateException("操作符不是一个函数")})
            return eggOp.apply(argList)
        } else {
            throw EvaluateException("操作符不是一个函数或特殊形式" + this.op.toString())
        }
    }

    public override func toString(): String {
        let argStrs = Array<String>(this.args.size, item: "")
        for (i in 0..this.args.size) {
            argStrs[i] = this.args[i].toString() + " "
        }
        return "(${this.op.toString()} ${argStrs.toString()})"
    }
}

class EvaluateException <: Exception {
    public init(message: String) {
        super(message)
    }
}

