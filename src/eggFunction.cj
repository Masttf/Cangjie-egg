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
        
        return Object()
    }
}