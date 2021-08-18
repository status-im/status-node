import json, random, strutils, strformat, tables, chronicles, unicode, times
from sugar import `=>`, `->`
import stint
from times import getTime, toUnix, nanosecond

proc prefix*(methodName: string, isExt:bool = true): string =
  result = "waku"
  result = result & (if isExt: "ext_" else: "_")
  result = result & methodName

proc handleRPCErrors*(response: string) =
  let parsedReponse = parseJson(response)
  if (parsedReponse.hasKey("error")):
    raise newException(ValueError, parsedReponse["error"]["message"].str)

proc toStUInt*[bits: static[int]](flt: float, T: typedesc[StUint[bits]]): T =
  var stringValue =  fmt"{flt:<.0f}"
  stringValue.removeSuffix('.')
  if (flt >= 0):
    result = parse($stringValue, StUint[bits])
  else:
    result = parse("0", StUint[bits])

proc toUInt256*(flt: float): UInt256 =
  toStUInt(flt, StUInt[256])

proc toUInt64*(flt: float): StUInt[64] =
  toStUInt(flt, StUInt[64])

proc eth2Wei*(eth: float, decimals: int = 18): UInt256 =
  let weiValue = eth * parseFloat(alignLeft("1", decimals + 1, '0'))
  weiValue.toUInt256

proc gwei2Wei*(gwei: float): UInt256 =
  eth2Wei(gwei, 9)

proc wei2Eth*(input: Stuint[256], decimals: int = 18): string =
  var one_eth = u256(10).pow(decimals) # fromHex(Stuint[256], "DE0B6B3A7640000")

  var (eth, remainder) = divmod(input, one_eth)
  let leading_zeros = "0".repeat(($one_eth).len - ($remainder).len - 1)

  fmt"{eth}.{leading_zeros}{remainder}"

proc wei2Eth*(input: string, decimals: int): string =
  try:
    var input256: Stuint[256]
    if input.contains("e+"): # we have a js string BN, ie 1e+21
      let
        inputSplit = input.split("e+")
        whole = inputSplit[0].u256
        remainder = u256(10).pow(inputSplit[1].parseInt)
      input256 = whole * remainder
    else:
      input256 = input.u256
    result = wei2Eth(input256, decimals)
  except Exception as e:
    error "Error parsing this wei value", input, msg=e.msg
    result = "0"
  
proc first*(jArray: JsonNode, fieldName, id: string): JsonNode =
  if jArray == nil:
    return nil
  if jArray.kind != JArray:
    raise newException(ValueError, "Parameter 'jArray' is a " & $jArray.kind & ", but must be a JArray")
  for child in jArray.getElems:
    if child{fieldName}.getStr.toLower == id.toLower:
      return child

proc any*(jArray: JsonNode, fieldName, id: string): bool =
  if jArray == nil:
    return false
  result = false
  for child in jArray.getElems:
    if child{fieldName}.getStr.toLower == id.toLower:
      return true

proc isEmpty*(a: JsonNode): bool =
  case a.kind:
  of JObject: return a.fields.len == 0
  of JArray: return a.elems.len == 0
  of JString: return a.str == ""
  of JNull: return true
  else:
    return false

proc find*[T](s: seq[T], pred: proc(x: T): bool {.closure.}): T {.inline.} =
  let results = s.filter(pred)
  if results.len == 0:
    return default(type(T))
  result = results[0]

proc find*[T](s: seq[T], pred: proc(x: T): bool {.closure.}, found: var bool): T {.inline.} =
  let results = s.filter(pred)
  if results.len == 0:
    found = false
    return default(type(T))
  result = results[0]
  found = true

proc isUnique*[T](key: T, existingKeys: var seq[T]): bool =
  # If the key doesn't exist in the existingKeys seq, add it and return true.
  # Otherwise, the key already existed, so return false.
  # Can be used to deduplicate sequences with `deduplicate[T]`.
  if not existingKeys.contains(key):
    existingKeys.add key
    return true
  return false

proc deduplicate*[T](txs: var seq[T], key: (T) -> string) =
  var existingKeys: seq[string] = @[]
  txs.keepIf(tx => tx.key().isUnique(existingKeys))
