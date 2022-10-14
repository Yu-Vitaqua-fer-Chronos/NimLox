import strformat, strutils

import ./exceptions
import ./tokens

type LoxLexer* = object
  code: string
  tokens: seq[Token]
  startPos: int
  pos: int
  line: int
  hadError*: bool

proc init*(_: typedesc[LoxLexer], code: string): LoxLexer =
  result = LoxLexer(code: code)
  result.tokens = newSeq[Token](0)
  result.pos = 0
  result.line = 1
  result.hadError = false

proc scanString(l: var LoxLexer) =
  template getChar(): char = l.code[l.pos]
  template getCharAtPos(val: int): char = l.code[val]

  proc getLookahead(l: LoxLexer): char =
    if l.pos >= l.code.high:
      return '\0'
    return getCharAtPos(l.pos+1)

  template tokens(): seq[Token] = l.tokens

  l.pos += 1

  while (l.pos <= l.code.high) and (getChar() != '"'):
    l.pos += 1

  if l.pos > l.code.high:
    nloxError(l.line, "Unterminated string literal from position {l.startPos} to {l.pos}!".fmt)
    return

  let value = l.code.substr(l.startPos + 1, l.pos - 1)
  tokens.add Token.new(STRING, value, l.startPos, l.line)


proc scanTokens*(l: var LoxLexer): seq[Token] =
  template getChar(): char = l.code[l.pos]
  template getCharAtPos(val: int): char = l.code[val]

  proc getLookahead(l: LoxLexer): char =
    if l.pos >= l.code.high:
      return '\0'
    return getCharAtPos(l.pos+1)

  template tokens(): seq[Token] = l.tokens

  while l.pos < l.code.high:
    l.startPos = l.pos

    let cchar = getChar()
    let lookahead = l.getLookahead()

    case getChar()
      of '(':
        tokens.add Token.new(LEFT_PAREN, cchar, l.startPos, l.line)

      of ')':
        tokens.add Token.new(RIGHT_PAREN, cchar, l.startPos, l.line)

      of '{':
        tokens.add Token.new(LEFT_BRACE, cchar, l.startPos, l.line)

      of '}':
        tokens.add Token.new(RIGHT_BRACE, cchar, l.startPos, l.line)

      of ',':
        tokens.add Token.new(COMMA, cchar, l.startPos, l.line)

      of '.':
        tokens.add Token.new(DOT, cchar, l.startPos, l.line)

      of '-':
        tokens.add Token.new(MINUS, cchar, l.startPos, l.line)

      of '+':
        tokens.add Token.new(PLUS, cchar, l.startPos, l.line)

      of ';':
        tokens.add Token.new(SEMICOLON, cchar, l.startPos, l.line)

      of '*':
        tokens.add Token.new(STAR, cchar, l.startPos, l.line)

      of '!':
        if lookahead == '=':
          tokens.add Token.new(BANG_EQUAL, cchar & lookahead, l.startPos, l.line)
          l.pos += 1 # As we're also using the lookahead
        else:
          tokens.add Token.new(BANG, cchar, l.startPos, l.line)

      of '=':
        if lookahead == '=':
          tokens.add Token.new(EQUAL_EQUAL, cchar & lookahead, l.startPos, l.line)
          l.pos += 1
        else:
          tokens.add Token.new(EQUAL, cchar, l.startPos, l.line)

      of '<':
        if lookahead == '=':
          tokens.add Token.new(LESS_EQUAL, cchar & lookahead, l.startPos, l.line)
          l.pos += 1
        else:
          tokens.add Token.new(LESS, cchar, l.startPos, l.line)

      of '>':
        if lookahead == '=':
          tokens.add Token.new(GREATER_EQUAL, cchar & lookahead, l.startPos, l.line)
          l.pos += 1
        else:
          tokens.add Token.new(GREATER, cchar, l.startPos, l.line)

      of '/':
        # Comments get ignored completely
        if lookahead == '/':
          l.pos += 2
          while (l.pos <= l.code.high) and (getChar() != '\n'):
            l.pos += 1

          l.pos -= 1 # For newline
        else:
          tokens.add Token.new(SLASH, cchar, l.startPos, l.line)

      of '"':
        l.scanString()

      of '\n':
        l.line += 1

      of {' ', '\r', '\t'}:
        discard

      else:
        l.hadError = true
        let escchar = escape($cchar, "`", "`")
        nloxError l.line, "Character {escchar} starting at position {l.startPos}, line {l.line} is invalid!".fmt

    l.pos += 1

  tokens.add Token.new(EOF, "<<EOF>>", l.pos, l.line)

  return tokens
