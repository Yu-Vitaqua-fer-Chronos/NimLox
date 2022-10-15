import strformat

type TokenTypes* = enum
  # Single-character tokens.
  LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE,
  COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR,

  # One or two character tokens.
  BANG, BANG_EQUAL,
  EQUAL, EQUAL_EQUAL,
  GREATER, GREATER_EQUAL,
  LESS, LESS_EQUAL,

  # Literals.
  IDENTIFIER, STRING, NUMBER,

  # Keywords.
  AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR,
  PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE,

  # Misc.
  EOF


type Token* = object
  tokenType*: TokenTypes
  literal: string
  startPos*: int
  line*: int

proc lexeme*(t: Token): string =
  if t.tokenType == STRING:
    result.addQuoted(t.literal)

  else:
    return t.literal

proc literal*(t: Token): string =
  if t.tokenType notin {STRING}:
    return t.literal

  else:
    return ""

proc new*(_: typedesc[Token], tokenType: TokenTypes, literal: string | char,
  startPos, line: int): Token =
    when literal is char:
      result = Token(tokenType: tokenType, literal: $literal, startPos: startPos,
        line: line)
    else:
      result = Token(tokenType: tokenType, literal: literal, startPos: startPos,
        line: line)

proc `$`*(t: Token): string =
  result = "(Token: {t.tokenType}, Literal: {t.literal}, ".fmt &
    "Lexeme: {t.lexeme}, Line: {t.line})".fmt
