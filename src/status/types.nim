import json, options, typetraits, tables, sequtils, strutils
import json_serialization, stint
import libstatus/accounts/constants
import ../eventemitter

type SignalType* {.pure.} = enum
  Message = "messages.new"
  Wallet = "wallet"
  NodeReady = "node.ready"
  NodeCrashed = "node.crashed"
  NodeStarted = "node.started"
  NodeStopped = "node.stopped"
  NodeLogin = "node.login"
  EnvelopeSent = "envelope.sent"
  EnvelopeExpired = "envelope.expired"
  MailserverRequestCompleted = "mailserver.request.completed"
  MailserverRequestExpired = "mailserver.request.expired"
  DiscoveryStarted = "discovery.started"
  DiscoveryStopped = "discovery.stopped"
  DiscoverySummary = "discovery.summary"
  SubscriptionsData = "subscriptions.data"
  SubscriptionsError = "subscriptions.error"
  WhisperFilterAdded = "whisper.filter.added"
  CommunityFound = "community.found"
  Stats = "stats"
  Unknown

proc event*(self:SignalType):string =
  result = "signal:" & $self

type RpcError* = ref object
  code*: int
  message*: string

type
  RpcResponse* = ref object
    jsonrpc*: string
    result*: string
    id*: int
    error*: RpcError
  # TODO: replace all RpcResponse and RpcResponseTyped occurances with a generic
  # form of RpcReponse. IOW, rename RpceResponseTyped*[T] to RpcResponse*[T] and
  # remove RpcResponse.
  RpcResponseTyped*[T] = object
    jsonrpc*: string
    result*: T
    id*: int
    error*: RpcError

type
  StatusGoException* = object of CatchableError

type
  RpcException* = object of CatchableError


proc `%`*(stuint256: Stuint[256]): JsonNode =
  newJString($stuint256)

proc readValue*(reader: var JsonReader, value: var Stuint[256])
               {.raises: [IOError, SerializationError, Defect].} =
  try:
    let strVal = reader.readValue(string)
    value = strVal.parse(Stuint[256])
  except:
    try:
      let intVal = reader.readValue(int)
      value = intVal.stuint(256)
    except:
      raise newException(SerializationError, "Expected string or int representation of Stuint[256]")
