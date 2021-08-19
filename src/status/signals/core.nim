import NimQml, tables, json, chronicles, strutils, json_serialization
import ../types as status_types
import types, stats, discovery
import ../status
import ../../eventemitter

logScope:
  topics = "signals"

QtObject:
  type SignalsController* = ref object of QObject
    variant*: QVariant
    status*: Status

  proc setup(self: SignalsController) =
    self.QObject.setup
  
  proc newController*(status: Status): SignalsController =
    new(result)
    result.status = status
    result.variant = newQVariant(result)
    result.setup()

  proc delete*(self: SignalsController) =
    self.variant.delete
    self.QObject.delete

  proc processSignal(self: SignalsController, statusSignal: string) =
    var jsonSignal: JsonNode
    try: 
      jsonSignal = statusSignal.parseJson
    except:
      error "Invalid signal received", data = statusSignal
      return

    let signalString = jsonSignal["type"].getStr

    trace "Raw signal data", data = $jsonSignal

    var signalType: SignalType
    
    try:
      signalType = parseEnum[SignalType](signalString)
    except:
      warn "Unknown signal received", type = signalString
      signalType = SignalType.Unknown
      return
    var signal: Signal = case signalType:
      of SignalType.Stats: stats.fromEvent(jsonSignal)
      of SignalType.DiscoverySummary: discovery.fromEvent(jsonSignal)
      else: Signal()

    self.status.events.emit(signalType.event, signal)

  proc signalReceived*(self: SignalsController, signal: string) {.signal.}

  proc receiveSignal*(self: SignalsController, signal: string) {.slot.} =
    self.processSignal(signal)
    self.signalReceived(signal)
