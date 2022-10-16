import ../tokens

type Expr* = object of RootObj # So it's inheritable

type Unary* = object of Expr
  operator*: Token
  right*: Expr

type Literal* = object of Expr
  value*: AstNode

type Binary* = object of Expr
  left*: Expr
  operator*: Token
  right*: Expr

type Grouping* = object of Expr
  expression*: Expr

proc new*(_: typedesc[Unary], operator: Token, right: Expr): Unary =
  return Unary(operator: operator, right: right)

proc new*(_: typedesc[Literal], value: AstNode): Literal =
  return Literal(value: value)

proc new*(_: typedesc[Binary], left: Expr, operator: Token, right: Expr): Binary =
  return Binary(left: left, operator: operator, right: right)

proc new*(_: typedesc[Grouping], expression: Expr): Grouping =
  return Grouping(expression: expression)

