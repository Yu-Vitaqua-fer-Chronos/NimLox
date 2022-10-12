import ./exceptions
import ./tokens

type LoxLexer* = object
  code: string
  tokens: seq[Token]
  startPos: int
  pos: int
  line: int

proc init*(_: typedesc[LoxLexer], code: string): LoxLexer =
  result = LoxLexer(code: code)
  result.tokens = newSeq[Token]()
  result.startPos = 0
  result.pos = 0
  result.line = 1

proc advance(l: var LoxLexer): char =
  result = l.code[l.pos]
  l.pos += 1

proc scanToken(l: var LoxLexer) =
  var c = l.advance()

  case c
  of 

proc scanTokens*(l: var LoxLexer): seq[Token] =
  while l.pos < l.code.high:
    l.startPos = l.pos

    l.scanToken()

  l.tokens.add Token.new(EOF, "", "", l.line)
