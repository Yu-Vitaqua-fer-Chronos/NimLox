import os

import ./src/[
  lexer,
  exceptions
]

let PROMPT = "Usage: " & paramStr(0) & " [script]"

if paramCount() > 1:
  quit(PROMPT, 64)

proc run(code: string) =
  var lexer = LoxLexer.init(code)
  lexer.scanTokens()

proc runFile(file: string) =
  run(readFile(paramStr(1)))

proc runPrompt() =
  while true:
    var code = ""

    try:
      while true:
        stdout.write("nlox> ")
        let line = stdin.readLine()

        if line == "":
          break

        code &= line & "\n"

      run(code)
    except NloxParsingDefect as e:
      stderr.write("Parsinf defect!")


if paramCount() == 0:
  runPrompt()
else:
  runFile(paramStr(1))
