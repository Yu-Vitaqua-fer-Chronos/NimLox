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
  lexeme*: string
  startPos*: int
  line*: int

proc new*(_: typedesc[Token], tokenType: TokenTypes, lexeme: string | char,
  startPos, line: int): Token =
    when lexeme is char:
      result = Token(tokenType: tokenType, lexeme: $lexeme, startPos: startPos,
        line: line)
    else:
      result = Token(tokenType: tokenType, lexeme: lexeme, startPos: startPos,
        line: line)

proc `$`*(t: Token): string =
  result = "(Token: {t.tokenType}, Lexeme: {t.lexeme}, ".fmt &
    "Line: {t.line})".fmt
