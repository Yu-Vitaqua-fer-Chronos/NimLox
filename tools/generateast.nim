#!/usr/bin/env -S nim c

import os
import strformat
import strutils
import tables

if paramCount() != 1:
  quit(fmt"Usage: {paramStr(0)} <output directory>", 64)


type NamedType = object
  name*: string
  typ*: string


proc defineAst(outputDir, baseObject: string, astTypesArr: openArray[string]) =
  var code = """import ../tokens

type Expr* = object of RootObj # So it's inheritable

proc new(_: typedesc[Binary], left: Expr, operator: Token, right: Expr): Binary =
  return Binary(left: left, operator: operator, right: right)

"""

  var types, newProcs: string

  var astTypes: Table[string, seq[NamedType]]

  for astType in astTypesArr.items:
    var resArr = astType.split(':')

    for i in 0..resArr.high:
      resArr[i] = resArr[i].strip()

    astTypes[resArr[0]] = newSeq[NamedType]()

    var namedTypes = resArr[1].split(',')

    for i in 0..namedTypes.high:
      namedTypes[i] = namedTypes[i].strip()

    for namedTypePair in namedTypes:
      var ntp = namedTypePair.split('|')
      astTypes[resArr[0]].add NamedType(name: ntp[1], typ: ntp[0])

  for tname in astTypes.keys:
    var newTypeCode = "type {tname}* = object of {baseObject}\n".fmt
    var newConstructorProc = "proc new*(_: typedesc[{tname}], ".fmt
    var newConstructedType = "  return {tname}(".fmt

    for i in 0..astTypes[tname].high:
      let namedType = astTypes[tname][i]

      newTypeCode &= "  {namedType.name}*: {namedType.typ}\n".fmt
      newConstructorProc &= "{namedType.name}: {namedType.typ}".fmt
      newConstructedType &= "{namedType.name}: {namedType.name}".fmt

      if i == astTypes[tname].high:
        newConstructorProc &= "): {tname} =\n".fmt
        newConstructedType &= ")\n\n".fmt
        newTypeCode &= "\n"
      else:
        newConstructorProc &= ", ".fmt
        newConstructedType &= ", ".fmt

    types &= newTypeCode
    newProcs &= newConstructorProc & newConstructedType

  code &= types & newProcs

  outputDir.createDir

  writeFile(outputDir / "expressions.nim", code)


let outputDir = paramStr(1)

const AST_TYPES = [
  "Binary   : Expr|left, Token|operator, Expr|right",
  "Grouping : Expr|expression",
  "Literal  : string|value",
  "Unary    : Token|operator, Expr|right"
]

defineAst(outputDir, "Expr", AST_TYPES)