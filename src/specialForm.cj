package egg
interface SpecialForm {
  	func apply(args: Array<Expression>, env: Env): Object;
}
/**
 * 实现 'if' 特殊形式。
 * 语法: (if condition consequence alternative)
 */
class IfSpacialForm <: SpecialForm {
	public override func apply(args: Array<Expression>, env: Env): Object {
		if(args.size != 3) {
			throw Exception("if 语句需要三个参数")
		}
		let test = args[0].evaluate(env)
		let flag = (test as Bool).getOrThrow({=> Exception("if 语句参数必须是布尔值")})
		if(flag == true) {
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
		if(args.size != 2) {
			throw Exception("while 语句需要两个参数")
		}
		let condition = args[0]
		let body = args[1]
		// 记录循环体最后一次执行的结果，如果循环从未执行，Egg 返回 false
		var lastResult = false
		while(true) {
			let test = condition.evaluate(env)
			let flag = (test as Bool).getOrThrow({=> Exception("while 语句参数必须是布尔值")})
			if(flag == false) {
				break
			}
			body.evaluate(env)
			lastResult = true
		}
		return Utils.convertToObejct(lastResult)
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
		var lastResult = Utils.convertToObejct(false)
		for(arg in args) {
			lastResult = arg.evaluate(env)
		}
		return lastResult
	}
 }

 