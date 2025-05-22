package egg;


interface Expression {
  	func evaluate(env: Env): Object
}

//值表达式
class ValueExpression <: Expression { 
	var value: Object;
	public init(value: Object) {
		this.value = value;
	}

	public override func evaluate(env: Env): Object {
		return this.value;
	}
}

//标识符表达式
class WordExpression <: Expression { 
	var name: String;
	public init(name: String) {
		this.name = name;
	}

  	public override func evaluate(env: Env): Object {
		let value = env.get(this.name)
		return value.getOrThrow({=> Exception("未定义的变量: ${this.name}")})
  	}
}

//应用表达式
class ApplyExpression <: Expression {
	var op: Expression;
	var args: Array<Expression>;

	public init(op: Expression, args: Array<Expression>) {
		this.op = op;
		this.args = args;
	}
	func getArgList(args: Array<Expression>, env: Env): Array<Object> {
		let argList = Array<Object>(args.size, item: Object())
		for(i in 0..args.size) {
			let arg = args[i]
			let value = arg.evaluate(env)
			argList[i] = value
		}
		return argList
	}
  	public override func evaluate(env: Env): Object {
    	let opValue:Object = this.op.evaluate(env)

    	if (opValue is SpecialForm) {
			let spcialOp = (opValue as SpecialForm).getOrThrow({=> Exception("操作符不是一个特殊形式")})
			return spcialOp.apply(this.args, env)
    	} else if (opValue is EggFunction) {
			let argList = getArgList(this.args, env)
			let eggOp = (opValue as EggFunction).getOrThrow({=> Exception("操作符不是一个函数")})
      		return eggOp.apply(argList)
		} else {
			throw Exception("操作符不是一个函数或特殊形式")
		}
  	}
}

