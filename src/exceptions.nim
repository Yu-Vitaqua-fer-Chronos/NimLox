import strformat

# TODO: Make proper exceptions

type NloxParsingDefect* = object of Defect

proc report(line: int, where, msg: string) =
  if where != "":
    raise NloxParsingDefect.newException(fmt"[L{line}] Error {where}: {msg}")
  else:
    raise NloxParsingDefect.newException(fmt"[L{line}] Error: {msg}")

proc nloxError*(line: int, msg: string) =
  report(line, "", msg)
