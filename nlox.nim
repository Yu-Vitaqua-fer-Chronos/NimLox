import os

import ./src/[
  lexer,
  exceptions
]

let prompt = "Usage: " & paramStr(0) & " [script]"

if paramCount() > 1:
  quit(prompt, 64)

proc run(code: string) =
  var lexer = LoxLexer.init(code)
  var tokens = lexer.scanTokens()

  if lexer.hadError:
    return

  echo tokens

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
