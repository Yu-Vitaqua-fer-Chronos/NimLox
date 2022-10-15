import ../tokens

type
  Expr* = object of RootObj # So it's inheritable

  Binary* = object of Expr
  left*: Expr
  operator*: Token
  right*: Expr

proc new(_: typedesc[Binary], left: Expr, operator: Token, right: Expr): Binary =
  return Binary(left: left, operator: operator, right: right)