package egg

import std.collection.*

interface SpecialForm {
    func apply(args: Array<Expression>, env: Env): Object;
}

/**
 * 实现 'if' 特殊形式。
 * 语法: (if condition consequence alternative)
 */
class IfSpacialForm <: SpecialForm {
    public override func apply(args: Array<Expression>, env: Env): Object {
        if (args.size != 3) {
            throw Exception("if 语句需要三个参数")
        }
        let test = args[0].evaluate(env)
        let flag = (test as Value<Bool>).getOrThrow({=> Exception("if 语句参数必须是布尔值")})
        if (flag.value == true) {
            return args[1].evaluate(env)
        } else {
            return args[2].evaluate(env)
        }
    }
}

/**
 * 实现 'while' 特殊形式。
 * 语法: (while condition body)
 */
class WhileSpacialForm <: SpecialForm {
    public override func apply(args: Array<Expression>, env: Env): Object {
        if (args.size != 2) {
            throw Exception("while 语句需要两个参数")
        }
        let condition = args[0]
        let body = args[1]
        // 记录循环体最后一次执行的结果，如果循环从未执行，Egg 返回 false
        var lastResult = false
        while (true) {
            let test = condition.evaluate(env)
            let flag = (test as Value<Bool>).getOrThrow({=> Exception("while 语句参数必须是布尔值")})
            if (flag.value == false) {
                break
            }
            body.evaluate(env)
            lastResult = true
        }
        return Value<Bool>(lastResult)
    }
}

/**
 * 实现 'do' 特殊形式。
 * 语法: (do expr1 expr2 ... exprN)
 * 按顺序执行所有表达式，并返回最后一个表达式的结果。
 */
class DoSpacialForm <: SpecialForm {
    public override func apply(args: Array<Expression>, env: Env): Object {
        // 如果没有参数，Egg 返回 false
        if (args.size == 0) {
            return Value<Bool>(false)
        }
        var lastResult = Object()
        for (arg in args) {
            lastResult = arg.evaluate(env)
        }
        return lastResult
    }
}

/**
 * 实现 'define' 特殊形式。
 * 语法: (define name value) 或 (define name(params...) body) [函数定义语法糖，这里简化只处理变量定义]
 * 用于在当前环境中定义（或重新定义）一个变量。
 */
class DefineSpacialForm <: SpecialForm {
    public override func apply(args: Array<Expression>, env: Env): Object {
        // 检查参数数量和第一个参数类型（必须是 WordExpression）
        if (args.size != 2 || !(args[0] is WordExpression)) {
            throw Exception("无效的 'define' 语法。用法: (define 变量名 值表达式)")
        }
        
        let wordexpr = (args[0] as WordExpression).getOrThrow({=> Exception("define 语句第一个参数必须是变量名")})
        let name = wordexpr.name
        let value = args[1].evaluate(env)
        env.define(name, value)
        return value
    }
}

/**
 * 实现 'fun' 特殊形式。
 * 语法: (fun (param1 param2 ...) body)
 * 用于创建（但不执行）一个匿名函数（闭包）。
 */
class FunSpacialForm <: SpecialForm {
    public override func apply(args: Array<Expression>, env: Env): Object {
        // 检查参数数量和第一个参数类型（必须是 ApplyExpression）
        if (args.size != 2 || !(args[0] is ApplyExpression)) {
            throw Exception("无效的 'fun' 语法。用法: (fun (参数列表) 函数体)")
        }
        
        let paramExpr = args[0]
        let paramNames = extractParamNames(paramExpr)
        let body = args[1]
        
        return UserDefinedFunction(paramNames, body, env)
    }

    func extractParamNames(paramExpr: Expression): Array<String> {
        let paramNames = ArrayList<String>()
        if (paramExpr is ApplyExpression) {
            let applyExpr = (paramExpr as ApplyExpression).getOrThrow({=> Exception("fun 语法错误")})
            // 如果操作符是标识符，也将其作为参数名（处理单个参数的情况）
            if (applyExpr.op is WordExpression) {
                let wordExpr = (applyExpr.op as WordExpression).getOrThrow({=> Exception("fun 语法错误")})
                paramNames.append(wordExpr.name)
            }
            for (arg in applyExpr.args) {
                if (arg is WordExpression) {
                    let wordExpr = (arg as WordExpression).getOrThrow({=> Exception("fun 语法错误")})
                    paramNames.append(wordExpr.name)
                } else {
                    throw Exception("fun 语法错误，参数必须是标识符")
                }
            }
        } else {
            throw Exception("fun 语法错误，参数列表必须是括号包围的表达式")
        }
        return paramNames.toArray()
    }
}
