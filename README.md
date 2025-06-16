# Egg 语言的cangjie实现

### egg编程语言

egg语言来自《eloquent javascript》

> 解释器，它决定了编程语言中表达式的含义，只是一个程序。
>
> Hal Abelson and Gerald Sussman, Structure and Interpretation of Computer Programs


![Illustration](https://eloquentjavascript.net/img/chapter_picture_12.jpg)

构建自己的编程语言出人意料地容易（只要你不要定得太高），而且非常令人豁然开朗。

在这一章中，我想展示的主要内容是，构建编程语言并没有什么魔法。我经常觉得某些人类发明如此聪明和复杂，以至于我永远无法理解它们。但通过一点阅读和实验，它们往往变得相当平凡。

我们将构建一种名为 Egg 的编程语言。这将是一种小巧简单的语言——但足以表达你所能想到的任何计算。它将允许基于函数的简单抽象。

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

  