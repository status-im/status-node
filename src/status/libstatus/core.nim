import json, chronicles
import status_go, ../utils

logScope:
  topics = "rpc"

proc callRPC*(inputJSON: string): string =
  return $status_go.callRPC(inputJSON)

proc callPrivateRPCRaw*(inputJSON: string): string =
  return $status_go.callPrivateRPC(inputJSON)

proc callPrivateRPC*(methodName: string, payload = %* []): string =
  try:
    let inputJSON = %* {
      "jsonrpc": "2.0",
      "method": methodName,
      "params": %payload
    }
    debug "callPrivateRPC", rpc_method=methodName
    let response = status_go.callPrivateRPC($inputJSON)
    result = $response
    if parseJSON(result).hasKey("error"):
      writeStackTrace()
      error "rpc response error", result, payload, methodName
  except Exception as e:
    error "error doing rpc request", methodName = methodName, exception=e.msg

