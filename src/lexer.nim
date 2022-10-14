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

proc getLookahead(lex: LoxLexer): char =
  if lex.pos >= lex.code.high:
    return '\0'
  return lex.code[lex.pos+1]

template defaultScanTmpls(l: var LoxLexer) =
  template getChar(): char = l.code[l.pos]
  template tokens(): seq[Token] = l.tokens

# TODO: Finish this off
proc scanMultilineComment(l: var LoxLexer) =
  l.defaultScanTmpls()

  var nest = 0

  let startLine = l.line

  l.pos += 2 # Skip first nest
  while l.pos <= l.code.high:
    if getChar == '/':
      l.pos += 1
      if getChar == '*':
        nest += 1
    else:
      l.pos += 1

  if l.pos > l.code.high:
    nloxError(startLine, "Unterminated multiline comment from position {l.startPos} to {l.pos}!".fmt)
    return

proc scanIdentifier(l: var LoxLexer) =
  l.defaultScanTmpls()

  while getChar.isAlphaNumeric:
    l.pos += 1

  let ident = l.code.substr(l.startPos, l.pos - 1)

  if getChar != ' ':
    l.pos -= 1

  case ident
    of "and":
      tokens.add Token.new(AND, ident, l.startPos, l.line)

    of "class":
      tokens.add Token.new(CLASS, ident, l.startPos, l.line)

    of "else":
      tokens.add Token.new(ELSE, ident, l.startPos, l.line)

    of "false":
      tokens.add Token.new(FALSE, ident, l.startPos, l.line)

    of "for":
      tokens.add Token.new(FOR, ident, l.startPos, l.line)

    of "fun":
      tokens.add Token.new(FUN, ident, l.startPos, l.line)

    of "if":
      tokens.add Token.new(IF, ident, l.startPos, l.line)

    of "nil":
      tokens.add Token.new(NIL, ident, l.startPos, l.line)

    of "or":
      tokens.add Token.new(OR, ident, l.startPos, l.line)

    of "print":
      tokens.add Token.new(PRINT, ident, l.startPos, l.line)

    of "return":
      tokens.add Token.new(RETURN, ident, l.startPos, l.line)

    of "super":
      tokens.add Token.new(SUPER, ident, l.startPos, l.line)

    of "this":
      tokens.add Token.new(THIS, ident, l.startPos, l.line)

    of "true":
      tokens.add Token.new(TRUE, ident, l.startPos, l.line)

    of "var":
      tokens.add Token.new(VAR, ident, l.startPos, l.line)

    of "while":
      tokens.add Token.new(WHILE, ident, l.startPos, l.line)

    else:
      tokens.add Token.new(IDENTIFIER, ident, l.startPos, l.line)

proc scanNumber(l: var LoxLexer) =
  l.defaultScanTmpls()

  var cchar = getChar()
  while (cchar.isDigit) or (cchar == '.'):
    l.pos += 1
    cchar = getChar()

  let value = l.code.substr(l.startPos, l.pos-1)

  if count(value, '.') > 1:
    nloxError(l.line, fmt"`{value}` is an invalid number literal!")
    return

  tokens.add Token.new(NUMBER, value, l.startPos, l.line)

proc scanString(l: var LoxLexer) =
  l.defaultScanTmpls()

  l.pos += 1

  while (l.pos <= l.code.high) and (getChar() != '"'):
    l.pos += 1

  if l.pos > l.code.high:
    nloxError(l.line, "Unterminated string literal from position {l.startPos} to {l.pos}!".fmt)
    return

  let value = l.code.substr(l.startPos + 1, l.pos - 1)
  tokens.add Token.new(STRING, value, l.startPos, l.line)


proc scanTokens*(l: var LoxLexer): seq[Token] =
  l.defaultScanTmpls()

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
        if cchar.isDigit:
          l.scanNumber()

        elif cchar.isAlphaAscii:
          l.scanIdentifier()

        else:
          l.hadError = true
          let escchar = escape($cchar, "`", "`")
          nloxError l.line, "Character {escchar} starting at position {l.startPos}, line {l.line} is invalid!".fmt

    l.pos += 1

  tokens.add Token.new(EOF, "<<EOF>>", l.pos, l.line)

  return tokens
