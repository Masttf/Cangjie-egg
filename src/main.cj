package egg
import std.console.*
main(): Int64 {
    var test = "(printf \"hello\")"
    runProgram(test)
    //简单运算符
    test = "(printf (+ 1 2 3) (* 4 5))"
    runProgram(test)
    //定义并调用函数
    test = "(do (define plusOne (fun (a) (+ a 1))) \n" +
                "    (printf \"plusOne(10) 的结果:\" (plusOne 10)))"
    runProgram(test)

    // 递归函数 (计算幂)
    test = "(do (define pow (fun (base exp) \n" +
                "                (if (== exp 0) \n" +
                "                    1 \n" +
                "                    (* base (pow base (- exp 1)))))) \n" +
                "    (printf \"2 的 10 次方:\" (pow 2 10)))"
    runProgram(test)

    //作用域与闭包
    test = "(do (define f (fun (a) (fun (b) (+ a b)))) \n" +
                "    (define add5 (f 5)) \n" +
                "    (printf \"add5(10) 的结果:\" (add5 10)))"
    runProgram(test)

    runRepl()
    return 0
}
func runProgram(program: String): Unit {
    println("------------------------------")
    println("执行程序")
    try {
        let expr : Expression = Parser(program).parse(program)
        let result = expr.evaluate(TopLevel.create())
        println("结果: ${Utils.convertObjectToString(result)}")
    } catch(e : ParseException) {
        println("解析错误: ${e.message}")
    } catch(e : EvaluateException) {
        println("求值错误: ${e.message}")
    } catch(e : Exception) {
        println("错误: ${e.message}")
    }
    println("------------------------------")
    
}

func runRepl(): Unit {
    println("Egg REPL (输入 'exit' 退出)")
    while(true) {
        print("egg> ")
        let input:String = (Console.stdIn.readln()).getOrThrow({=> Exception("读取输入失败")})
        if(input == "exit") {
            break
        }
        if(Utils.isBank(input)){
            continue
        }
        // println("输入: ${input}")
        try {
            let expr : Expression = Parser(input).parse(input)
            let result = expr.evaluate(TopLevel.create())
            println("结果: ${Utils.convertObjectToString(result)}")
        } catch(e : ParseException) {
            println("解析错误: ${e.message}")
        } catch(e : EvaluateException) {
            println("求值错误: ${e.message}")
        } catch(e : Exception) {
            println("错误: ${e.message}")
        }
    }
}