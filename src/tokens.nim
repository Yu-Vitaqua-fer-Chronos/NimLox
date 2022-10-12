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
  literal*: string
  line*: int

proc new*(_: typedesc[Token], tokenType: TokenTypes, lexeme, literal: string,
  line: int): Token =
    result = Token(tokenType: tokenType, lexeme: lexeme, literal: literal,
      line: line)

proc `$`*(t: Token): string =
  result = "(Token: {t.tokenType}, Lexeme: {t.lexeme}, Literal: ".fmt &
    "{t.literal}, Line: {t.line})".fmt
