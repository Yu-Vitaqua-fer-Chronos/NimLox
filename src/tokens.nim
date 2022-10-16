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

type AstNodeKinds* = enum
  anString, anInteger, anFloat, anBoolean

type AstNode* = object
  case kind:
    of anString:
      strVal: string
    of anInteger:
      intVal: BiggestInt
    of anFloat:
      floatVal: BiggestFloat
    of anBoolean:
      boolVal: bool

proc toAstNode*(literal: string): AstNode = AstNode(kind: anString, strVal: literal)
proc toAstNode*(literal: BiggestInt): AstNode = AstNode(kind: anInteger, intVal: literal)
proc toAstNode*(literal: BiggestFloat): AstNode = AstNode(kind: anFloat, floatVal: literal)
proc toAstNode*(literal: bool): AstNode = AstNode(kind: anBoolean, boolVal: literal)

type Token* = object
  tokenType*: TokenTypes
  lexeme*: string
  literal*: AstNode
  startPos*: int
  line*: int

proc new*(_: typedesc[Token], tokenType: TokenTypes, lexeme: string | char,
  literal: AstNode, startPos, line: int): Token =
    when lexeme is char:
      result = Token(tokenType: tokenType, lexeme: $lexeme, literal: literal, startPos: startPos,
        line: line)
    else:
      result = Token(tokenType: tokenType, lexeme: lexeme, literal: literal, startPos: startPos,
        line: line)

proc `$`*(t: Token): string =
  result = "(Token: {t.tokenType}, Literal: {t.literal}, ".fmt &
    "Lexeme: {t.lexeme}, Line: {t.line})".fmt
