import strformat

# TODO: Make proper exceptions

type NloxParsingDefect* = object of Defect

proc report(line: int, msg: string, where: string="") =
  if where != "":
    #raise NloxParsingDefect.newException(fmt"[L{line}] Error {where}: {msg}")
    echo fmt"[L{line}] Error {where}: {msg}"
  else:
    #raise NloxParsingDefect.newException(fmt"[L{line}] Error: {msg}")
    echo fmt"[L{line}] Error: {msg}"

proc nloxError*(line: int, msg: string) =
  report(line, msg, "")
