package egg
main(): Int64 {
    var test = "(printf \"hello\")"
    runProgram(test)

    test = "(printf (+ 1 2 3) (* 4 5))"
    runProgram(test)
    return 0
}
func runProgram(program: String): Unit {
    println("执行程序")
    println("------------------------------")
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