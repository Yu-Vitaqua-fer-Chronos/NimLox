#!/usr/bin/env -S nim c --run -

import os
import strformat
import strutils
import tables

if paramCount != 1:
  quit("Usage: {paramStr(0)} <output directory>", 64)

type NamedType = object
  name*: string
  typ*: string

proc defineAst(outputDir, baseObject: string, astTypesArr: openArray[string]) =
  var astTypes: Table[string, seq[NamedType]]

  for astType in astTypesArr.items:
    var resArr = astType.split(':')

    astTypes[resArr[0]] = newSeq[NamedType]()

    var namedTypes = resArr[1].split(", ")

    for namedTypePair in namedTypes:
      var ntp = namedTypePair.split('|')
      astTypes[resArr[0]].add NamedType(name: ntp[1], typ: ntp[0])

let outputDir = paramStr(1)

const AST_TYPES = [
  "Binary   : Expr|left, Token|operator, Expr|right",
  "Grouping : Expr|expression",
  "Literal  : string|value",
  "Unary    : Token|operator, Expr|right"
]

defineAst(outputDir, "Expr", AST_TYPES)