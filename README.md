# Egg 语言的cangjie实现

## 类型介绍

- 数值类型 Float64

- 字符串类型被 `""`包裹不支持 `\`转义

- 数组

  ```
  array param1 param2 ...
  ```

- 函数一等公民

  ```
  (fun (param1 param2 ...) body)
  ```

- bool

​	ture false

## 语法

- 使用`()` 为应用表达式，不支持(1)

- 定义变量

  ```
  (define name value) 或 (define name(params...) body)
  ```

- if

  ```
  (if condition consequence alternative)
  ```

- while

  ```
  (while condition body)
  ```

- do 按顺序执行所有表达式，并返回最后一个表达式的结果。

  ```
  (do expr1 expr2 ... exprN)
  ```

## 基本运算

- 加法 返回 param1 + param2 + ... + paramN

  ```
  (+ param1 param2 ...)
  ```

- 减法 返回 param1 - param2 -  ... + paramN

  ```
  (- param1 param2 ...)
  ```

- 乘法 返回 param1 * param2 * ... * paramN

  ```
  (* param1 param2 ...)
  ```

- 除法 返回 dividend / divisor

  ```
  (/ dividend divisor)
  ```

- 大于 返回 bool

  ```
  (> param1 param2)
  ```

- 小于 返回 bool

  ```
  (< param1 param2)
  ```

- 等于 返回 bool

  ```
  (== param1 param2)
  ```

## 内置函数

- printf 输出

  ```
  (printf param1 param2 ...)
  ```

- element 访问index位置的值

  ```
  (element arrayOrString index)
  ```

- length 输出数组或者字符串的长度

  ```
  (length arrayOrSring)
  ```

  